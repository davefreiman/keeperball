module Keeperball
  module GoogleApi
    class Client::Read < Client

      def execute
        import_team_players
      end

      private

      attr_reader :sheet_id

      def import_team_players
        return unless worksheet.present?

        legend.each do |name, team|
          x = team['x_start'].to_i
          y = team['y_start'].to_i
          y_end = team['y_end'].to_i
          roster = Keeperball::Roster.where(team_key: team['team_key']).first
          while y <= y_end do
            name = worksheet[y, x].strip
            player = Keeperball::Player.where(name: /#{name}/i).first
            player.roster_id = roster.id
            player.salary = worksheet[y, (x+1)]
            player.expiry = worksheet[y, (x+2)]
            player.contract_type = import_contract(worksheet[y, (x+3)].strip)
            player.save
            y += 1
          end
          roster.save
        end
      end

      def import_contract(value)
        return 'extension' if value.downcase == 'extension'
        return 'franchise' if value.downcase == 'tag'
        'entry'
      end
    end
  end
end
