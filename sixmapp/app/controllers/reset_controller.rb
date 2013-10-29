class ResetController < ApplicationController
  before_action :set_user, only: [:actual]
  
  #reset request form
  def new
  end

  #generates reset link and sends email out
  def generate
    user = User.find_by_email(params[:email])
    ResetMailer.reset_password_email(user).deliver
    return render_success({status:"success", message:"email sent"})
  end
  
  #pass word reset form
  def password
    if params[:success] != "1"
      @user = User.find(params[:id])
    end
  end

  #actually resets password
  def actual
    binding.pry
    if @user.reset_password(params[:password])
      return render_success({status:"success", message:"password reset"})
    else
      return render_success({status:"error", message:"password reset failed"})
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
