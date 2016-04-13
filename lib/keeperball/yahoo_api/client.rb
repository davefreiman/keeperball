module Keeperball
  module YahooApi
    class Client
      attr_reader :type, :token
      attr_accessor :request, :response

      def initialize(token, type)
        @token = token
        @type = type
      end

      def execute
        build_request
        do_request
        parse_response
      end

      private

      def build_request
        builder_class =
          "Keeperball::YahooApi::Builder::#{type.classify}".constantize
        self.request = builder_class.new.build
      end

      def do_request
        self.response = token.get(self.request)
      end

      def parse_response
        self.response = Nokogiri::XML(self.response.body)
      end
    end
  end
end
