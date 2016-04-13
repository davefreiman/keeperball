module Keeperball
  module Import
    class Transactions
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def ingest
        transactions = document.css('transactions transaction')
        transactions.each do |transaction|
          import(transaction)
        end

        true
      end

      private

      def import(transaction)

      end
    end
  end
end