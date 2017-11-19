class Api::V1::PlaysController < Api::V1::ApiController
  def start
    game = Game.find_by(slug: play_params[:game])
    play = Play.create(game: game, arcade_machine: @arcade_machine, start: Time.now.utc)

    if play.save
      render json: play.to_json
    else
      render json: { errors: play.errors.full_messages }
    end
  end

  def stop
    game = Game.find_by(slug: play_params[:id])
    play = @arcade_machine.plays.where(game: game, stop: nil).order(start: :desc).first

    raise ActiveRecord::RecordNotFound, "Play session not found: #{params}" if !play

    if play.update(stop: Time.now.utc)
      render json: play.to_json
    else
      render json: { errors: play.errors.full_messages }
    end
  end

  private

  def play_params
    params.permit(:id, :game)
  end
end
