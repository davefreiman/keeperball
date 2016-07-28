class TradesController < ApplicationController
  def index
    @trades = Keeperball::Transaction.
      where(move_type: 'trade').order('completed_at ASC')
  end

  def show
  end

  def new
    @trade = Keeperball::Transaction.new
  end

  def create
    @trade = Keeperball::Transaction.new(move_type: 'trade', pending: true)

    processor = Keeperball::Transaction::Processor.new(@trade, trade_params)
    processor.process

    raise ''
  end

  def update
  end

  def propose
  end

  def decline
  end

  def accept
  end

  private

  def trade_params
    params.permit(
      :from_team,
      :send_cap,
      :to_team,
      :get_cap,
      send_players: [],
      get_players: []
    )
  end
end
