class SessionsController < ApplicationController
  #exceptions = login + signup + logout
  skip_before_filter :require_user, :only => [:new, :create]
  def new
    render "new"
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      render "new"
    end  
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  end

end
