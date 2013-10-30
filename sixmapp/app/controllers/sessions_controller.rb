class SessionsController < ApplicationController
  #exceptions = login + signup + logout
  skip_before_filter :require_user, :only => [:new, :create]
  def new
    render "new"
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user
      session[:user_id] = user.id
      redirect_to stream_index_path
      #goes to user#show
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
