module Google
  class OauthController < ApplicationController
    before_action :require_admin

    def authorize
      url = client.authorize_url.to_s
      redirect_to(url)
    end

    def callback
      code = params[:code]
      access_token = client.access_token(code)
      current_user.update_attributes(
        google_access_token: access_token,
        google_access_token_expiry: Time.now + 3600
      )
      GoogleDrive.login_with_oauth(access_token)
    end

    private

    def client
      @client ||= Keeperball::GoogleApi::WebClient.new(request, current_user)
    end
  end
end
