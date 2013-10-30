class ResetController < ApplicationController
  skip_before_filter :require_user, :only => [:new, :generate, :password, :change_password]
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
      @id_hash = params[:id]
    end
  end

  #actually resets password
  def change_password
    @user = User.find(Rails.configuration.encryptor.decrypt_and_verify(params[:id]))
    if @user.reset_password(params[:password])
      return render_success({status:"success", message:"password reset"})
    else
      return render_success({status:"error", message:"password reset failed"})
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
