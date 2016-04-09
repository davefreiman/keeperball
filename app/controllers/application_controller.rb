class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    return @current_user if defined?(@current_user)

    @current_user ||=
      User.find(cookies.signed[:user_id]) if cookies.signed[:user_id].present?
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to root_path, error: 'Login Required' unless current_user
  end
end
