require 'googleauth/stores/file_token_store'

module Keeperball
  module GoogleApi
    class WebClient
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

      def initialize(request, user)
        @client_id = Keeperball::Application.config.google_auth[:client_id]
        @client_secret =
          Keeperball::Application.config.google_auth[:client_secret]
        @request = request
        @user = user
      end

      def authorize_url
        token_store = Google::Auth::Stores::FileTokenStore.new(file: "#{Rails.root}/tmp/tokens.yml")
        scope = ['https://www.googleapis.com/auth/drive', 'https://spreadsheets.google.com/feeds/']
        authorizer = Google::Auth::WebUserAuthorizer.new(
          formatted_client_id, scope, token_store, redirect_uri)
        authorizer.get_authorization_url(login_hint: user.id, request: request)
      end

      def access_token(code)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: "#{Rails.root}/tmp/tokens.yml")
        scope = ['https://www.googleapis.com/auth/drive', 'https://spreadsheets.google.com/feeds/']
        authorizer = Google::Auth::WebUserAuthorizer.new(
          formatted_client_id, scope, token_store, redirect_uri)
        auth = authorizer.get_and_store_credentials_from_code(
          user_id: user.id, code: code, base_url: OOB_URI)
        auth.access_token
      end

      def refresh_token(token)
        client = Google::APIClient.new
        auth = client.authorization
        auth.client_id = client_id
        auth.client_secret = client_secret
        auth.scope =
          'https://www.googleapis.com/auth/drive ' +
          'https://spreadsheets.google.com/feeds/'
        auth.redirect_uri = redirect_uri
        auth.refresh_token = token
        auth.refresh!
        GoogleDrive.login_with_oauth(auth.access_token)
      end

      def current_session(user)
        return false unless user.google_access_token.present?
        return false if user.has_expired_google_token?

        token = user.google_access_token
        return refresh_token(token) if user.has_expired_google_token?
        GoogleDrive::Session.new(token)
      end

      private
      attr_reader :client_id, :client_secret, :request, :user

      def redirect_uri
        'http://localhost:3000/google/oauth/callback'
      end

      def formatted_client_id
        formatted_client = { id: client_id, secret: client_secret}
        OpenStruct.new(formatted_client)
      end
    end
  end
end
