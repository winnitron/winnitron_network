class GamesController < ApplicationController
  include StatsHelper

  before_action :set_game, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :permission_check!, except: [:index, :show, :new, :create]

  def index
    set_sort

    @mine   = user_signed_in? ? current_user.games.order(title: :asc) : Game.none
    @theirs = Game.published
                  .includes(:images)
                  .where.not(id: @mine.map(&:id))

    case @sort
    when "new"
      @theirs = @theirs.reorder(published_at: :desc)
    when "name"
      @theirs = @theirs.reorder(title: :asc)
    end
  end

  def new
    @game = Game.new
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

  def save_keys
    if @game.key_map.update(template: params[:template], custom_map: params[:key_map])
      render json: @game.key_map
    else
      render json: { errors: @game.key_map.full_messages }, status: :unprocessable_entity
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

  def stats
    start = params[:start] ? Date.parse(params[:start]) : 7.days.ago.to_date
    stop = params[:stop] ? Date.parse(params[:stop]) : Date.today

    @start = start.iso8601
    @stop = stop.iso8601
    @plays = @game.plays.includes(:arcade_machine)
                        .complete
                        .where(start: start.beginning_of_day..stop.end_of_day)
                        .order(start: :asc)

    @total = @plays.to_a.sum(&:duration)

    respond_to do |format|
      format.html {}
      format.json { render json: build_plays_json(@plays) }
      format.csv { render text: build_plays_csv(@plays) }
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

  def set_sort
    valid = ["new", "name"]
    @sort = valid.include?(params[:sort]) ? params[:sort].downcase : "new"
    @active_sort = {}
    @active_sort[@sort.to_sym] = "active"
  end

  def permission_check!
    require_admin_or_ownership!(@game)
  end

  def game_params
    params.fetch(:game, {}).permit(:title, :description, :min_players, :max_players, :tag_list,
                                   links_attributes: [:id, :link_type, :url, :_destroy])
  end
end
