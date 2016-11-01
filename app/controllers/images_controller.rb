class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :uuid_permission_check!

  def create
    Image.create!(game_uuid: @game.uuid,
                  user: current_user,
                  file_key: "games/#{@game.uuid}-image-#{params[:filename]}",
                  file_last_modified: Time.parse(params[:lastModifiedDate]))

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