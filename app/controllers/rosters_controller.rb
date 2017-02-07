class RostersController < ApplicationController
  def index
    @rosters = Keeperball::Roster.all
  end

  def show
  end

  def trade_form
    @roster = Keeperball::Roster.where(team_key: roster_params[:roster]).first
    @team_type = roster_params[:team_type]

    respond_to do |format|
      format.js do
        render partial: 'trades/player_fields',
          locals: { roster: @roster, team_type: @team_type }
      end
    end
  end

  def update
  end

  private

  def roster_params
    params.permit(:roster, :team_type)
  end
end
