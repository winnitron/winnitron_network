class ListingsController < ApplicationController
  before_action :set_playlist
  before_action :permission_check!

  def create
    game = Game.find params[:game_id]
    listing = Listing.find_or_create_by! game: game, playlist: @playlist

    respond_to do |format|
      format.html { redirect_to games_path, notice: "Game(s) added" }
      format.json { render json: listing }
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to @listing.playlist, notice: 'Game removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_playlist
    @playlist = if params[:playlist_id]
      Playlist.find(params[:playlist_id])
    else
      Listing.find(params[:id]).playlist
    end
  end

  def permission_check!
    if user_signed_in? && (current_user.admin? || current_user == @playlist.user)
      true
    else
      head :forbidden
    end
  end

end