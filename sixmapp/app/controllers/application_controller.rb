class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_user
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def new_broadcasts
    @new_broadcasts = current_user.get_new_broadcasts
  end
  helper_method :new_broadcasts

  def render_success_plain(body)
    render json: body, status: 200, callback: params[:callback]
  end

  def render_success(body)
    render json: body.to_json, status: 200, callback: params[:callback]
  end

  def render_unauthorized(body)
    render json: body.to_json, status: 401, callback: params[:callback]
  end

  def render_bad_request(body)
    render json: body.to_json, status: 406, callback: params[:callback]
  end

  def render_failure(body)
    render json: body.to_json, status: 412, callback: params[:callback]
  end

  # private

  def require_user
    if current_user
      unless current_user.email
        redirect_to users_edit_path(current_user)
      end
    else
      redirect_to welcome_path
    end
  end
end
