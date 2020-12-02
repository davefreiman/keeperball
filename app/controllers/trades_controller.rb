class TradesController < ApplicationController
  before_action :find_trade, only: %i(accept decline show update)
  before_action :ensure_pending, only: %i(accept decline)

  def index
    @trades = Keeperball::Transaction.
      from_season(season).
      where(move_type: 'trade').
      order('completed_at ASC')
  end

  def pickups
    @trades = Keeperball::Transaction.
      from_season(season).
      where(move_type: 'add').
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
    if processor.process && @trade.save
      redirect_to trades_path, notice: 'Trade Saved, notifying managers'
    else
      flash.now[:alert] =
        'Trade failed to save: ' +
        "#{@trade.errors.first.first.to_s} #{@trade.errors.first.second}"
      render :new
    end
  end

  def update
  end

  def propose
  end

  def decline
    if @trade.delete
      redirect_to trades_path,
                  notice: 'Trade Declined!'
    else
      redirect_to trade_path(@trade),
                  alert: ['Trade failed to save:',
                          @trade.errors.first.first.to_s,
                          @trade.errors.first.second].join(' ')
    end
  end

  def accept
    if @trade.update(pending: false)
      redirect_to trades_path,
                  notice: 'Trade Accepted! You just got fleeced you idiot'
    else
      redirect_to trade_path(@trade),
                  alert: ['Trade failed to save:',
                          @trade.errors.first.first.to_s,
                          @trade.errors.first.second].join(' ')
    end
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

  def find_trade
    @trade ||= Keeperball::Transaction.find(params[:id])
  end

  def ensure_pending
    unless @trade.pending?
      redirect_to trade_path(@trade),
                  alert: 'Cannot Accept or Decline a non-pending trade'
    end
  end
end
