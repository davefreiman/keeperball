module Keeperball
  module Import
    class Transaction < Base
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