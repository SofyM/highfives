class ApplicationController < ActionController::Base
  before_action :require_authentication, except: [:authorize, :callback]
  helper_method :current_user

  private

  def require_authentication
    unless current_user
      redirect_to login_path
    end
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
