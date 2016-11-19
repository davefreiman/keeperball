module Keeperball
  module Seasonable
    extend ActiveSupport::Concern

    included do
      default_scope -> { where(yahoo_reference_key => /^#{current_key}\./) }

      scope :from_season, ->(y = current_year) do
        where(
          yahoo_reference_key => /^#{key_from_year(y)}\./
        ).order('completed_at ASC')
      end
    end

    class_methods do

      private

      def yahoo_reference_key
        :key
      end

      def current_key
        key_from_year(current_year)
      end

      def current_year
        Keeperball::Application.config.current_year
      end

      def key_from_year(year)
        Keeperball::Application.config.yahoo_game_ids[year]
      end
    end
  end
end
