module Keeperball
  module GoogleApi
    class Client::WriteTransaction < Client

      def execute
        process_transactions
      end

      private

      attr_reader :sheet_id

      def process_transactions
        return unless worksheet.present?

        Transaction.unprocessed.from_season(current_season).each do |t|
          type = t.move_type
          method = "process_#{type}"
          self.send(method, t.details)
          t.update_attributes(processed: true)
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
              player.expiry = current_season + 1
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
          if detail.cap.present?
            process_cap_movement(detail)
          else
            process_player_movement(detail)
          end
        end
      end

      def process_player_movement(detail)
        player = Keeperball::Player.find_by_key(detail.player_key)
        player.roster_id = detail.destination_team.id
        player.save
      end

      def process_cap_movement(detail)
        cap_moved = detail.cap
        dest_initial_cap = detail.destination_team.next_year_cap
        source_initial_cap = detail.source_team.next_year_cap

        detail.destination_team.set_next_year_cap(dest_initial_cap + cap_moved)
        detail.source_team.set_next_year_cap(source_initial_cap - cap_moved)
      end

      def write_result
        legend.each do |name, team|
          x = team['x_start'].to_i
          y = team['y_start'].to_i
          roster = Keeperball::Roster.where(team_key: team['team_key']).first
          worksheet[(y-2), (x+2)] = roster.next_year_cap

          roster.players.each do |player|
            worksheet[y, x] = player.name
            worksheet[y, (x+1)] = player.salary
            worksheet[y, (x+2)] = player.expiry
            worksheet[y, (x+3)] = write_contract(player.contract_type)
            y += 1
          end
          while (y - team['y_start'].to_i) < 12
            worksheet[y, x] = ''
            worksheet[y, (x+1)] = ''
            worksheet[y, (x+2)] = ''
            worksheet[y, (x+3)] = ''
            y += 1
          end
        end
        worksheet.save
      end

      def write_contract(value)
        return 'Extension' if value.downcase == 'extension'
        return 'Franchise Tag' if value.downcase == 'franchise'
        ''
      end

      def reset_salary?(player)
        !player.salary.present? || player.salary <= 12
      end
    end
  end
end
