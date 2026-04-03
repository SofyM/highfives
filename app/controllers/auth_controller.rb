class AuthController < ApplicationController
  skip_before_action :require_authentication, only: %i[login sso_redirect callback]

  def login
    render :login
  end

  def sso_redirect
    email = params[:email].to_s.strip
    domain = email.split("@").last

    connections = WorkOS::SSO.list_connections(domain: domain)

    if connections.data.empty?
      redirect_to login_path, alert: "No SSO connection found for #{domain}"
      return
    end

    auth_url = WorkOS::SSO.authorization_url(
      client_id: ENV["WORKOS_CLIENT_ID"],
      redirect_uri: ENV["WORKOS_REDIRECT_URI"],
      organization: connections.data.first.organization_id
    )

    redirect_to auth_url, allow_other_host: true
  end

  def callback
    error = params[:error]
    code = params[:code]

    if error.present? || code.blank?
      redirect_to login_path, alert: "Authentication failed: #{params[:error_description]}"
      return
    end

    begin
      result = WorkOS::SSO.profile_and_token(
        client_id: ENV["WORKOS_CLIENT_ID"],
        code: code
      )

      user = User.from_sso(result.profile)
      begin
        WorkosEventsSync.new(organization_id: result.profile.organization_id).call
      rescue StandardError => e
        Rails.logger.warn("WorkOS events sync failed: #{e.class}: #{e.message}")
      end
      user = User.find_by(id: user.id)
      if user.nil? || user.directory_state == "inactive"
        reset_session
        redirect_to login_path, alert: "Your account is inactive."
        return
      end

      session[:user_id] = user.id
      redirect_to home_path, notice: "Successfully logged in"
    rescue WorkOS::InvalidRequestError => e
      redirect_to login_path, alert: "Authentication failed: #{e.message}"
    end
  end

  def logout
    reset_session
    redirect_to login_path
  end
end
