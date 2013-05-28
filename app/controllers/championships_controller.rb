class ChampionshipsController < ApplicationController

  def index
    @championships = current_user.championships
  end

  def show
    # can show any championship not just one's own!
    @championship = Championship.find(params[:id])
  end

  def new
    @championship = current_user.championships.new
  end

  def create
    @championship = current_user.championships.new(params[:championship])
    if @championship.save
      redirect_to edit_championship_path(@championship), notice: 'Championship was successfully created.'
    else
      render action: :new
    end
  end

  def edit
    @championship = current_user.championships.find(params[:id].to_s)
  end

  def update
    @championship = current_user.championships.find(params[:id].to_s)
    attrs = params[:championship] ? params[:championship] : compile_attrs_from_xeditable(params)
    @championship.update_attributes(attrs)
    respond_to do |format|
      format.html {render action: :edit}
      format.json {render json: @championship.to_json}
    end
  end

  def destroy
    @championship = current_user.championships.find(params[:id])
    @championship.destroy
    redirect_to action: :index
  end

end
