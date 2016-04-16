module Keeperball
  module YahooApi
    class Client::Player < Client

      def execute
        while players_available
          build_request
          do_request
          parse_response
          ingest_response
        end

        true
      end

      private

      def players_available
        return true unless response.present?

        importer.has_players?
      end

      def build_request
        self.request = builder.build(importer.players_imported)
      end

      def ingest_response
        importer.document = response
        importer.ingest
      end

      def importer
        @importer ||= Keeperball::Import::Player.new(response)
      end

      def builder
        @builder ||= Keeperball::YahooApi::Builder::Player.new
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
