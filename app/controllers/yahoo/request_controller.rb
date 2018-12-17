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
      OAuth2::AccessToken.from_hash(
        auth.consumer,
        access_token: current_user.yahoo_access_token,
        refresh_token: current_user.yahoo_access_refresh_token,
        expires_at: current_user.yahoo_access_token_expiry
      )
    end

    def refresh_token
      return unless current_user.has_expired_access_token?
      access = auth.refresh_token(access_token)
      return unless access.present?
      current_user.update_attributes(
        yahoo_access_token: access.token,
        yahoo_access_token_expiry: Time.now + access.expires_in.seconds,
        yahoo_oauth_session_identifier: access.params[:oauth_session_handle],
        yahoo_access_refresh_token: access.refresh_token
      )
    end

    def auth
      @auth =
        Keeperball::YahooApi::Authorization.new({}, current_user)
    end
  end
end
