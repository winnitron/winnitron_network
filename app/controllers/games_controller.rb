class GamesController < ApplicationController
  before_action :set_game, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :permission_check!, except: [:index, :show, :new, :create]

  def index
    @mine   = user_signed_in? ? current_user.games.order(title: :asc) : Game.none
    @theirs = Game.published
                  .includes(:images)
                  .where.not(id: @mine.map(&:id))
                  .order(title: :asc)
  end

  def show
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    @game.users = [current_user]

    respond_to do |format|
      if @game.save
        format.html { redirect_to images_game_path(@game.slug) }
      else
        format.html { render :new }
      end
    end
  end

  def images
  end

  def zip
  end

  def executable
    if zip = @game.current_zip
      zip.update(executable: zip.likely_executable) if !zip.executable
    else
      redirect_to zip_game_path(@game.slug)
    end
  end

  def update
    if @game.update(game_params)
      if @game.published?
        redirect_to @game, notice: "Game was successfully updated."
      else
        redirect_to images_game_path(@game.slug)
      end
    else
      render :edit
    end
  end

  def publish
    if @game.update(published_at: Time.now.utc)
      redirect_to @game, notice: "Your game has been published!"
    else
      # TODO: redirect somewhere and put this in flash
      render json: { errors: @game.errors.full_messages }
    end
  end

  def confirm_destroy
    @to_destroy = @game
    render "shared/confirm_destroy"
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
    @game = Game.find_by!(slug: params[:id])
  end

  def set_executable
    return if !@game.current_zip
    @game.current_zip.update(executable: game_params[:executable])
  end

  def permission_check!
    require_admin_or_ownership!(@game)
  end

  def game_params
    params.fetch(:game, {}).permit(:title, :description, :min_players, :max_players, :tag_list,
                                   links_attributes: [:id, :link_type, :url, :_destroy])
  end
end
