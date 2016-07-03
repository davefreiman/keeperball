class TradesController < ApplicationController
  def index
    @trades = Keeperball::Transaction.where(move_type: 'trade')
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def propose
  end

  def decline
  end

  def accept
  end
end
