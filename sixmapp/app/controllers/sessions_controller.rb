class SessionsController < ApplicationController
  #exceptions = login + signup + logout
  skip_before_filter :require_user, :only => [:new, :create]
  def new
    render "new"
  end

  def create
    user = User.find_or_create_by_oauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    # render text: request.env["omniauth.auth"].inspect
    redirect_to dashboard_path, notice: "Logged in as #{user.name}"
    # user = User.find_by(email: params[:session][:email])
    # if user && user.authenticate(params[:session][:password])
    #   session[:user_id] = user.id
    #   redirect_to dashboard_path
    # else
    #   render "new"
    # end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  end

end
