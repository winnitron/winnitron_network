class GameZipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :permission_check!

  def create
    zip = GameZip.new(game: @game,
                      user: current_user,
                      file_key: URI.decode(params[:filepath][1..-1]),
                      file_last_modified: Time.parse(params[:lastModifiedDate]))

    if zip.save
      render json: zip, status: :created
    else
      render json: { errors: zip.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def permission_check!
    require_admin_or_ownership!(@game)
  end
end