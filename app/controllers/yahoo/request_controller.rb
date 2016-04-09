module Yahoo
  class RequestController < ApplicationController
    def transactions
      auth = Keeperball::YahooApi::Authorization.new
      options = {
        oauth_token: session[:access_token],
        oauth_token_secret: session[:access_token_secret]
      }
      access_token = OAuth::AccessToken.new(auth.consumer, options[:oauth_token], options[:oauth_token_secret])
      adapter = Keeperball::YahooApi::Adapter::League.new(access_token)
      @response = adapter.do_request
    end
  end
end
