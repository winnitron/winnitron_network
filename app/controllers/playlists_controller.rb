class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :confirm_destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :permission_check!, only: [:edit, :update, :destroy, :confirm_destroy, :list_games]

  def index
    @mine   = user_signed_in? ? current_user.playlists.order(title: :asc) : []
    @theirs = Playlist.with_games
                      .where.not(id: @mine.map(&:id))
                      .order(default: :desc, title: :asc)
  end

  def show
  end

  def new
    initial_game = Game.published.where(id: params[:game_id]).first
    @playlist = Playlist.new(games: [initial_game].compact)
  end

  def edit
  end

  def all_listings
    mapping = current_user.playlists.each_with_object({}) do |playlist, hsh|
      hsh[playlist.id] = playlist.game_ids
    end
    render json: mapping
  end

  def create
    @playlist = Playlist.new(playlist_params.except(:game_id).merge(user: current_user))
    @playlist.games = Game.published.where(id: playlist_params[:game_id])

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to @playlist, notice: 'Playlist was successfully created.' }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @playlist.update(playlist_params.except(:game_id))
        format.html { redirect_to @playlist, notice: 'Playlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_destroy
    @to_destroy = @playlist
    render "shared/confirm_destroy"
  end

  def destroy
    @playlist.destroy
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: 'Playlist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_playlist
    @playlist = Playlist.find_by!(slug: params[:id])
  end

  def permission_check!
    require_admin_or_ownership!(@playlist)
  end

  def playlist_params
    params.fetch(:playlist, {}).permit(:title, :description, :game_id)
  end
end
