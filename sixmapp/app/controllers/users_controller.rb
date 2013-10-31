class UsersController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :create, :confirm]
  before_action :set_user, only: [:show, :destroy]
  before_action :set_secure_user, only: [:edit, :update, :resend]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  # POST /users
  # POST /users.json
  def create
    first_name, last_name, email, password = *params.values_at(:first_name, :last_name, :email, :password)

    if [first_name, last_name, email, password].any?(&:blank?)
      return render_success({status:"error", message: 'invalid create parameters'})
    end
    
    #User already exists
    if User.exists?(email: email.downcase)
      return render_success({status:"error", message:"user already exists"})
    end
    #create user
    User.transaction do
      @user = User.new(
        name: (first_name + " " + last_name).titleize,
        email: email.downcase,
        password: password,
        password_confirmation: password
      )
      if @user.save!
        render_success({status:"success", message:"created"})
      else
        render_success({status:"error", message:"user creation failed"})
      end
    end
  end
  
  def confirm
    @user = User.find(Rails.configuration.encryptor.decrypt_and_verify(params[:id]))
    if @user.confirm_user
      redirect_to "/users/edit?confirm=1"
    else
      redirect_to "/users/edit?confirm_fail=1"
    end
  end
 
  def resend
    UserMailer.confirmation_email(@user).deliver
    redirect_to :controller => 'users', :action => 'edit', :sent => 1 
  end
  
  def broadcast    
  end
  
  def broadcast_out
    admin_id = current_user.id
    message = params[:broadcast]
    b = BroadcastMessage.new(admin_id: admin_id, message: message) 
    if b.save
      redirect_to "/users/broadcast?broadcasted_out=1"
    end
  end
  
  def update
    if @user.update_attr(params)
      redirect_to "/users/edit?success=1" 
    else
      redirect_to "/users/edit?failure=1"
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    
    def set_secure_user
      @user = current_user
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
