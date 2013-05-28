class PlayersController < ApplicationController
  respond_to :html, :json

  def update
    @player = Player.find(params[:id].to_s)
    attrs = params[:player] ? params[:player] : compile_attrs_from_xeditable(params)
    @player.update_attributes(attrs)
    respond_with [@player.championship, @player]
  end

private
  def setup_championship
    @championship = current_user.championships.find(params[:championship_id])
  end
end
