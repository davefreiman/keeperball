module Keeperball
  module Import
    class Transaction < Base
      attr_accessor :transactions_imported

      def initialize(document)
        super(document)
        self.transactions_imported = 0
      end

      def ingest
        transactions = document.css('transactions transaction')
        self.transactions_imported += transactions.size
        transactions.each do |transaction|
          import(transaction)
        end

        true
      end

      def has_transactions?
        !document.css('transactions transaction').empty?
      end

      private

      def import(transaction)
        transaction_key = transaction.at_css('transaction_key').text
        move_type = translate_move_type(transaction.at_css('type').text)

        return true if move_type_invalid?(move_type)

        completed_at =
          DateTime.strptime(transaction.at_css('timestamp').text, '%s')
        keeper_transaction =
          Keeperball::Transaction.where(transaction_key: transaction_key)

        unless keeper_transaction.present?
          keeper_transaction = Keeperball::Transaction.new(
            transaction_key: transaction_key,
            move_type: move_type,
            completed_at: completed_at
          )

          transaction.css('player').each do |player|
            player_key = player.at_css('player_key').text
            detail_type = translate_detail_type(player.at_css('type').text)
            source = find_source(player)
            destination = find_destination(player)
            keeper_transaction.details.new(
              player_key: player_key,
              detail_type: detail_type,
              source: source,
              destination: destination
            )
          end

          keeper_transaction.save
        end
      end

      def translate_move_type(type)
        return 'add' if type == 'add/drop' || type == 'drop'
        type
      end

      def translate_detail_type(type)
        return 'free_agent' if type == 'freeagents'
        type
      end

      def find_source(player)
        if player.at_css('source_type').text == 'team'
          return player.at_css('source_team_key').text
        end

        player.at_css('source_type').text
      end

      def find_destination(player)
        if player.at_css('destination_type').text == 'team'
          return player.at_css('destination_team_key').text
        end

        player.at_css('destination_type').text
      end

      def move_type_invalid?(move_type)
        move_type == 'commish'
      end
    end
  end
end
