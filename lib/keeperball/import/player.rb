module Keeperball
  module Import
    class Player < Base
      attr_accessor :players_imported

      def initialize(document)
        super(document)
        self.players_imported = 0
      end

      def ingest
        players = document.css('players player')
        self.players_imported += players.size
        players.each do |player|
          import(player)
        end

        true
      end

      def has_players?
        !document.css('players player').empty?
      end

      private

      def import(player)
        player_key = player.at_css('player_key').text
        name = player.at_css('full').text
        positions = player.css('eligible_positions position').map(&:text)

        player = Keeperball::Player.where(player_key: player_key).first

        unless player.present?
          Keeperball::Player.create!(
            player_key: player_key,
            name: name,
            positions: positions
          )
        end
      end
    end
  end
end
