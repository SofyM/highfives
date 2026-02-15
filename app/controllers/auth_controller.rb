class AuthController < ApplicationController
  skip_before_action :ensure_session, only: [:authorize, :callback]

  def authorize
    render template: 'authorize'
  end

  def callback
    # Stub: just set session and redirect to home
    session[:user_id] = SecureRandom.hex(16)
    session[:user_name] = "Demo User"
    redirect_to home_path
  end

  def logout
    session.clear
    redirect_to auth_authorize_path, notice: "Logged out"
  end
end
