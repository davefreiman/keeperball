module Google
  class RequestController < ApplicationController
    before_filter :require_login
    before_filter :check_api_session

    def read
      run_import('read')
    end

    def write_transaction
      run_import('write_transaction')
    end

    private

    def run_import(type)
      client_class = "Keeperball::GoogleApi::Client::#{type.classify}"
      client = client_class.constantize.new(google_api_session)

      if client.execute
        redirect_to root_path, notice: 'Successfully processed ' + type
      else
        redirect_to root_path,
          notice: 'Failed miserably in an attempt to process ' + type
      end
    end

    def check_api_session
      redirect_to google_oauth_authorize_path unless google_api_session
    end

    def google_api_session
      @session ||=
        Keeperball::GoogleApi::WebClient.new(request, current_user).current_session(current_user)
    end
  end
end
