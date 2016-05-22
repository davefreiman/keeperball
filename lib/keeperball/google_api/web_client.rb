module Keeperball
  module GoogleApi
    class WebClient
      def initialize
        @client_id = Keeperball::Application.config.google_auth[:client_id]
        @client_secret =
          Keeperball::Application.config.google_auth[:client_secret]
      end

      def authorize_url
        client = Google::APIClient.new
        auth = client.authorization
        auth.client_id = client_id
        auth.client_secret = client_secret
        auth.scope =
          'https://www.googleapis.com/auth/drive ' +
          'https://spreadsheets.google.com/feeds/'
        auth.redirect_uri = redirect_uri
        auth.authorization_uri
      end

      def access_token(code)
        client = Google::APIClient.new
        auth = client.authorization
        auth.client_id = client_id
        auth.client_secret = client_secret
        auth.scope =
          'https://www.googleapis.com/auth/drive ' +
          'https://spreadsheets.google.com/feeds/'
        auth.redirect_uri = redirect_uri
        auth.code = code
        auth.fetch_access_token!
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
      attr_reader :client_id, :client_secret

      def redirect_uri
        Rails.application.routes.url_helpers.google_oauth_callback_url(
          host: 'friedgoods.com'
        )
      end
    end
  end

end
