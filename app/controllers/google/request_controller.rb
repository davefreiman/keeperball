module Google
  class RequestController < ApplicationController
    before_filter :require_login
    before_filter :check_api_session

    def read
      google_api_session
    end

    private

    def run_import(type)
      # client_class = "Keeperball::YahooApi::Client::#{type.classify}"
      # client = client_class.constantize.new(access_token, type)

      if client.execute
        redirect_to root_path, notice: 'Refreshed ' + type
      else
        redirect_to root_path, notice: 'Failed miserably to import ' + type
      end
    end

    def check_api_session
      redirect_to google_oauth_authorize_path unless google_api_session
    end

    def google_api_session
      @session ||=
        Keeperball::GoogleApi::WebClient.current_session(current_user)
    end
  end
end
