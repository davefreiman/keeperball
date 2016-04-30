module GoogleDrive
  module Web
    def login
      # OAuth2 code example for Web apps:
      #
      #   require "rubygems"
      #   require "google/api_client"
      #   client = Google::APIClient.new
      #   auth = client.authorization
      #   # Follow Step 1 and 2 of “Authorizing requests with OAuth 2.0” in
      #   # https://developers.google.com/drive/v3/web/about-auth to get a client ID and client secret.
      #   auth.client_id = "YOUR CLIENT ID"
      #   auth.client_secret = "YOUR CLIENT SECRET"
      #   auth.scope =
      #       "https://www.googleapis.com/auth/drive " +
      #       "https://spreadsheets.google.com/feeds/"
      #   auth.redirect_uri = "http://example.com/redirect"
      #   auth_url = auth.authorization_uri
      #   # Redirect the user to auth_url and get authorization code from redirect URL.
      #   auth.code = authorization_code
      #   auth.fetch_access_token!
      #   session = GoogleDrive.login_with_oauth(auth.access_token)
      #
      # auth.access_token expires in 1 hour. If you want to restore a session afterwards, you can store
      # auth.refresh_token somewhere after auth.fetch_access_token! above, and use this code:
      #
      #   require "rubygems"
      #   require "google/api_client"
      #   client = Google::APIClient.new
      #   auth = client.authorization
      #   # Follow "Create a client ID and client secret" in
      #   # https://developers.google.com/drive/web/auth/web-server] to get a client ID and client secret.
      #   auth.client_id = "YOUR CLIENT ID"
      #   auth.client_secret = "YOUR CLIENT SECRET"
      #   auth.scope =
      #       "https://www.googleapis.com/auth/drive " +
      #       "https://spreadsheets.google.com/feeds/"
      #   auth.redirect_uri = "http://example.com/redirect"
      #   auth.refresh_token = refresh_token
      #   auth.fetch_access_token!
      #   session = GoogleDrive.login_with_oauth(auth.access_token)
    end
  end
end
