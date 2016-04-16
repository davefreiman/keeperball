module Yahoo
  class RequestController < ApplicationController
    before_filter :require_login
    before_filter :refresh_token
    before_filter :access_token

    def transactions
      run_import('transactions')
    end

    def rosters
      run_import('rosters')
    end

    def players
      run_import('players')
    end

    private

    def run_import(type)
      client_class = "Keeperball::YahooApi::Client::#{type.classify}"
      client = client_class.constantize.new(access_token, type)

      if client.execute
        redirect_to root_path, notice: 'Refreshed ' + type
      else
        redirect_to root_path, notice: 'Failed miserably to import ' + type
      end
    end

    def access_token
      auth = Keeperball::YahooApi::Authorization.new({}, current_user)
      OAuth::AccessToken.new(
        auth.consumer,
        current_user.yahoo_access_token,
        current_user.yahoo_access_token_secret
      )
    end

    def refresh_token
      redirect_to oauth_authorize_path if current_user.has_expired_access_token?
    end
  end
end
