class ApplicationController < ActionController::Base
  before_action :ensure_session
  helper_method :current_user, :high_fives_store

  private

  def ensure_session
    unless session[:user_id]
      session[:user_id] = SecureRandom.hex(16)
      session[:user_name] = "User #{session[:user_id][0..7]}"
    end
  end

  def current_user
    {
      'id' => session[:user_id],
      'first_name' => session[:user_name].split.first,
      'last_name' => session[:user_name].split.last || "",
      'email' => "#{session[:user_name].downcase.gsub(' ', '.')}@example.com"
    }
  end

  def high_fives_store
    @@high_fives ||= {}
  end
end
