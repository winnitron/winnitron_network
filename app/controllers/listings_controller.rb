class ListingsController < ApplicationController
  # TODO: check playlist ownership

  def create
    (params[:games] || []).each do |game_id|
      Listing.find_or_create_by game_id: game_id, playlist_id: params[:playlist_id]
    end

    redirect_to games_path, notice: "Game(s) added"
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to @listing.playlist, notice: 'Game removed.' }
      format.json { head :no_content }
    end
  end

end