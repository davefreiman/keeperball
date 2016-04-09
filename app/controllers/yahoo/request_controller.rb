module Yahoo
  class RequestController < ApplicationController

    before_filter :require_login
    before_filter :access_token

    def transactions
      adapter = Keeperball::YahooApi::Adapter::Transactions.new(access_token)
      @response = adapter.do_request
    end

    private

    def access_token
      auth = Keeperball::YahooApi::Authorization.new

      # auth.refresh_token if current_user.has_expired_access_token?

      options = {
        oauth_token: current_user.yahoo_access_token,
        oauth_token_secret: current_user.yahoo_access_token_secret
      }
      OAuth::AccessToken.new(
        auth.consumer,
        options[:oauth_token],
        options[:oauth_token_secret]
      )
    end
  end
end
