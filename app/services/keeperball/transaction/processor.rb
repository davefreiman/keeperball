module Keeperball
  class Transaction::Processor
    attr_accessor :trade, :params

    def initialize(trade, params)
      @trade = trade
      @params = params.with_indifferent_access
    end

    def process
      process_send_players
      process_get_players
      process_send_cap
      process_get_cap
    end

    private

    def process_send_players
      return unless params[:send_players].present?

      params[:send_players].each do |player|
        trade.details.new(
          detail_type: 'trade',
          source: params[:from_team],
          destination: params[:to_team],
          player_key: player
        )
      end
    end

    def process_get_players
      return unless params[:send_players].present?

      params[:get_players].each do |player|
        trade.details.new(
          detail_type: 'trade',
          source: params[:to_team],
          destination: params[:from_team],
          player_key: player
        )
      end
    end

    def process_send_cap
      return unless params[:send_cap].presence.to_i > 0

      trade.details.new(
        detail_type: 'trade',
        source: params[:from_team],
        destination: params[:to_team],
        cap: params[:send_cap]
      )
    end

    def process_get_cap
      return unless params[:get_cap].presence.to_i > 0

      trade.details.new(
        detail_type: 'trade',
        source: params[:to_team],
        destination: params[:from_team],
        cap: params[:get_cap]
      )

    end
  end
end
