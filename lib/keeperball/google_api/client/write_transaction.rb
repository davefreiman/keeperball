module Keeperball
  module GoogleApi
    class Client::WriteTransaction < Client

      def initialize(session)
        @sheet_id = Keeperball::Application.config.google_sheet_id
        super
      end

      def execute
        process_transactions
      end

      private

      attr_reader :sheet_id

      def process_transactions
        transactions.each do |transaction|
          type = transaction.move_type
          method = "process_#{type}"
          self.send(method, transaction.details)
        end
        write_result
      end

      def process_add(details)
        details.each do |detail|
          type = detail.detail_type
          player = Keeperball::Player.find_by_key(detail.player_key)
          if type == 'add'
            roster = Keeperball::Roster.find_by_key(detail.destination)
            player.roster_id = roster.id
            if detail.source == 'freeagents' && reset_salary?(player)
              player.salary = 12
              player.expiry = 2017
              player.contract_type = 'entry'
            end
          else
            player.roster_id = nil
          end
          player.save
        end
      end

      def process_trade(details)
        details.each do |detail|
          player = Keeperball::Player.find_by_key(detail.player_key)
          destination = Keeperball::Roster.find_by_key(detail.destination)
          player.roster_id = destination.id
          player.save
        end
      end

      def write_result
        legend.each do |name, team|
          x = team['x_start'].to_i
          y = team['y_start'].to_i
          roster = Keeperball::Roster.where(team_key: team['team_key']).first
          roster.players.each do |player|
            worksheet[y, x] = player.name
            worksheet[y, (x+1)] = player.salary
            worksheet[y, (x+2)] = player.expiry
            worksheet[y, (x+3)] = write_contract(player.contract_type)
            y += 1
          end
        end
        worksheet.save
      end

      def worksheet
        @worksheet ||= spreadsheet.worksheets[0]
      end

      def transactions
        @transactions ||= Keeperball::Transaction.order('completed_at ASC')
      end

      def spreadsheet
        @spreadsheet ||=
          session.spreadsheet_by_key(sheet_id)
      end

      def legend
        @legend ||= begin
          file_path = "#{Rails.root}/data/sheet_index/2015_2016.json"
          file = File.read(file_path)
          JSON.parse(file)
        end
      end

      def write_contract(value)
        return 'Extension' if value.downcase == 'extension'
        return 'Tag' if value.downcase == 'franchise'
        ''
      end

      def reset_salary?(player)
        !player.salary.present? || player.salary <= 12
      end
    end
  end
end
