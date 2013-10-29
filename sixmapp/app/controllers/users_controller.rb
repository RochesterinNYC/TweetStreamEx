class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
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
      redirect_to "/confirm_successful"
    else
      redirect_to "/confirm_failed"
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
