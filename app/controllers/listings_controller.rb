class ListingsController < ApplicationController
  before_action :permission_check!

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

  private

  def permission_check!
    require_admin_or_ownership!(@playlist)
  end

end