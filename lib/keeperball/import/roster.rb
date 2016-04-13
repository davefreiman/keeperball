module Keeperball
  module Import
    class Roster < Base
      def ingest
        rosters = document.css('teams team')
        rosters.each do |roster|
          import(roster)
        end

        true
      end

      private

      def import(roster)
        team_key = roster.at_css('team_key').text
        name = roster.at_css('name').text
        roster = Keeperball::Roster.where(name: name).first
        Keeperball::Roster.create(name: name, team_key: team_key) unless roster
      end
    end
  end
end