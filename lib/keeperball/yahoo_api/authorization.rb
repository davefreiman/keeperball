module Keeperball
  module YahooApi
    class Authorization
      attr_reader :client_id, :client_secret, :oauth_params, :current_user

      def initialize(oauth_params = {}, user = nil)
        @client_id = Rails.application.secrets.yahoo[:client_id]
        @client_secret = Rails.application.secrets.yahoo[:client_secret]
        @oauth_params = oauth_params
        @current_user = user
      end

      def request_token
        @request_token ||=
          consumer.get_request_token(:oauth_callback => oauth_callback_url)
      end

      def access_token
        request_token = OAuth::RequestToken.from_hash(consumer, user_tokens)
        request_token.get_access_token
      end

      def refresh_token
        return unless current_user.has_expired_access_token?
        request_token =
          OAuth::RequestToken.from_hash(consumer, user_access_tokens)
        request_token.get_access_token
      end

      def oauth_callback_url
        Rails.application.routes.url_helpers.oauth_callback_url(
          host: 'friedgoods.com'
        )
      end

      def consumer
        @consumer ||=
          OAuth::Consumer.new(client_id, client_secret, consumer_params)
      end

      def consumer_params
        {
          :access_token_url  => access_token_url,
          :authorize_url     => authorize_token_url,
          :request_token_url => request_url
        }.merge(oauth_params)
      end

      private

      def request_url
        'https://api.login.yahoo.com/oauth/v2/get_request_token'
      end

      def access_token_url
        'https://api.login.yahoo.com/oauth/v2/get_token'
      end

      def authorize_token_url
        'https://api.login.yahoo.com/oauth/v2/request_auth'
      end

      def user_tokens
        return unless current_user
        {
          oauth_token: current_user.yahoo_oauth_token,
          oauth_token_secret: current_user.yahoo_oauth_token_secret
        }
      end

      def user_access_tokens
        return unless current_user
        {
          oauth_token: current_user.yahoo_access_token,
          oauth_token_secret: current_user.yahoo_access_token_secret
        }.merge(session_id)
      end

      def session_id
        { oauth_session_handle: current_user.yahoo_oauth_session_identifier }
      end
    end
  end
end
