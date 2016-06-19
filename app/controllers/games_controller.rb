class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :s3_callback]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :permission_check!, only: [:edit, :update, :destroy, :s3_callback]

  def index
    @games = Game.all
  end

  def show
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def s3_callback
    @game.update zipfile_key: "games/#{params[:filename]}",
                 zipfile_last_modified: Time.parse(params[:lastModifiedDate])
    render nothing: true
  end

  def create
    @game = Game.new(game_params)
    @game.users = [current_user]

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@game)
  end

  def game_params
    params.fetch(:game, {}).permit(:title, :description, :zipfile_key, :tag_list, :website)
  end
end
