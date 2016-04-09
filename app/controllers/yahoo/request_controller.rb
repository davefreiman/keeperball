module Yahoo
  class RequestController < ApplicationController

    before_filter :require_login

    def transactions
      auth = Keeperball::YahooApi::Authorization.new
      options = {
        oauth_token: current_user.yahoo_access_token,
        oauth_token_secret: current_user.yahoo_access_token_secret
      }
      access_token = OAuth::AccessToken.new(auth.consumer, options[:oauth_token], options[:oauth_token_secret])
      adapter = Keeperball::YahooApi::Adapter::League.new(access_token)
      @response = adapter.do_request
    end
  end
end
