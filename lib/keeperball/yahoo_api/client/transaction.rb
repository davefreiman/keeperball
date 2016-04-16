module Keeperball
  module YahooApi
    class Client::Transaction < Client

      def execute
        while transactions_available
          build_request
          do_request
          parse_response
          ingest_response
        end

        true
      end

      def transactions_available
        return true unless response.present?

        importer.has_transactions?
      end

      def build_request
        self.request = builder.build(importer.transactions_imported)
      end

      def ingest_response
        importer.document = response
        importer.ingest
      end

      def builder
        @builder ||= Keeperball::YahooApi::Builder::Transaction.new
      end
    end
  end
end
