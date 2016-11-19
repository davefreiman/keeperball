class TradesController < ApplicationController
  def index
    @trades = Keeperball::Transaction.
      from_season(season).
      where(move_type: 'trade').
      order('completed_at ASC')
  end

  def show
  end

  def new
    @trade = Keeperball::Transaction.new
  end

  def create
    @trade = Keeperball::Transaction.new(
      move_type: 'trade',
      pending: true,
      transaction_key: current_year_key + '.custom_' + SecureRandom.uuid,
      completed_at: DateTime.now # TODO: get rid of this so we can have managers accept
    )

    processor = Keeperball::Transaction::Processor.new(@trade, trade_params)
    if processor.process && @trade.save!
      redirect_to trades_path, notice: 'Trade Saved, notifying managers'
    end
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

  def season
    (params[:season] || current_year).to_i
  end
end
