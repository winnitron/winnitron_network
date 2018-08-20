class GameZipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :permission_check!

  def create
    time = if params[:lastModifiedDate].present?
      Time.parse(params[:lastModifiedDate])
    else
      Time.now.utc
    end

    zip = GameZip.new(game: @game,
                      user: current_user,
                      file_key: URI.decode(params[:filepath][1..-1]),
                      file_last_modified: time)
    if zip.save
      render json: zip, status: :created
    else
      render json: { errors: zip.errors }, status: :unprocessable_entity
    end
  end

  def update
    @zip = @game.game_zips.find(params[:id])

    if @zip.update(executable: params[:filename])
      render json: @zip, status: :ok
    else
      render json: { errors: @zip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def root_files
    @zip = @game.game_zips.find(params[:id])
    render :root_files, layout: false
  end

  private

  def set_game
    @game = Game.find_by(id: params[:game_id])
  end

  def permission_check!
    require_admin_or_ownership!(@game)
  end
end