class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :logged_in?

  def current_user
    @current_user ||=
      User.find(cookies.signed[:user_id]) if cookies.signed[:user_id].present?
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to root_path, notice: 'Login Required' unless current_user
  end

  def require_admin
    return unless current_user&.admin?
    redirect_to root_path, notice: 'Forbidden'
  end

  private

  def current_year_key
    Keeperball::Application.config.yahoo_game_ids[current_year]
  end

  def current_year
    Keeperball::Application.config.current_year
  end
end
