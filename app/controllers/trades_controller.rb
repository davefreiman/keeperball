class TradesController < ApplicationController
  def index
    @trades = Keeperball::Transaction.where(move_type: 'trade').order('completed_at ASC')
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
