class Api::V1::HighScoresController < Api::V1::ApiController

  before_action :signed_authentication!, only: [:create]

  def index
  end

  def create
    machine = find_arcade_machine(params[:winnitron_id])

    high_score = HighScore.new(game: @game,
                     arcade_machine: machine,
                               name: params[:name],
                              score: params[:score])

    if params[:winnitron_id] && !machine
      render json: {
        errors: ["Could not find Winnitron #{params[:winnitron_id]}"]
      }, status: :unprocessable_entity
    elsif high_score.save
      render json: high_score, status: :created
    else
      render json: {
        errors: high_score.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def find_arcade_machine(winnitron_id)
    key = ApiKey.find_by(token: winnitron_id)
    key ? key.parent : ArcadeMachine.find_by(slug: winnitron_id)
  end
end
