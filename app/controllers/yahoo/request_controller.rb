module Yahoo
  class RequestController < ApplicationController

    before_filter :require_login
    before_filter :access_token

    def transactions
      adapter = Keeperball::YahooApi::Adapter::League.new(access_token)
      @response = adapter.do_request
    end

    private

    def access_token
      auth = Keeperball::YahooApi::Authorization.new({}, current_user)

      access = auth.refresh_token if current_user.has_expired_access_token?

      current_user.update_attributes(
        yahoo_access_token: access.token,
        yahoo_access_token_secret: access.secret,
        yahoo_access_token_expiry: Time.now + 3600,
        yahoo_oauth_session_identifier: access.params[:oauth_session_handle]
      ) if access.present?

      OAuth::AccessToken.new(
        auth.consumer,
        current_user.yahoo_access_token,
        current_user.yahoo_access_token_secret
      )
    end
  end
end
