class GameZipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :uuid_permission_check!

  def create
    zip = GameZip.create!(game_uuid: @game.uuid,
                          user: current_user,
                          file_key: "games/#{@game.uuid}-#{params[:filename]}",
                          file_last_modified: Time.parse(params[:lastModifiedDate]))

    render json: zip
  end

  def update
    if zip = GameZip.find_by(game_uuid: params[:uuid], file_key: "#{params[:file_key]}.zip")
      zip.update(executable: params[:executable])
    else
      Rails.logger.warn "Could not find GameZip with UUID #{params[:uuid]} and file_key #{params[:file_key]}.zip"
    end

    render nothing: true
  end

  private

  def set_game
    @game = Game.find_by(uuid: params[:uuid]) || Game.new(uuid: params[:uuid])
  end

  def uuid_permission_check!
    @game.new_record? || require_admin_or_ownership!(@game)
  end
end