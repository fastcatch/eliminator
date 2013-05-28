class MatchesController < ApplicationController

  before_filter :setup_championship

  def update
    @match = @championship.matches.find(params[:id].to_s)
    params[:match][:winner_id] = params[:match].delete(:winner) if params[:match].has_key? :winner
    possible_winners = @match.children.collect{|c| w = c.explicit_or_implicit_winner; w.id.to_s if w.present?}.compact
    params[:match][:winner_id] = nil unless possible_winners.include? params[:match][:winner_id]
    if @match && @match.update_attributes(params[:match])
      respond_to do |format|
        format.html { redirect_to edit_championship_url(@match.championship) }
        format.json { head :ok  }
      end
    else
      flash[:notice] = 'Error updating match.'
      respond_to do |format|
        format.html { render controller: :championship, action: :edit, id: @match.championship.id }
        format.json { head :bad_request  }
      end
    end
  end

private
  def setup_championship
    @championship = current_user.championships.find(params[:championship_id])
  end
end
