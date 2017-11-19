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
    play = @arcade_machine.plays.find(play_params[:id])
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
