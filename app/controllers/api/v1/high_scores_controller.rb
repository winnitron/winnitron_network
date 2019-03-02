class Api::V1::HighScoresController < Api::V1::ApiController
  include Sandbox

  before_action :signed_authentication!, only: [:create]

  def index
    scores = FilteredHighScores.new.game(@game)
                                   .arcade(params[:winnitron_id])
                                   .sandbox(sandbox?)
                                   .order("high")
                                   .limit(params[:limit] || 10)

    render json: { high_scores: scores }
  end

  def create
    machine = ArcadeMachine.find_by_identifier(params[:winnitron_id])

    high_score = HighScore.new(game: @game,
                     arcade_machine: machine,
                               name: params[:name],
                              score: params[:score],
                            sandbox: sandbox?)

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
end
