class Api::V1::AttractsController < Api::V1::ApiController
  def index
    render json: { attracts: @arcade_machine.attracts.select(&:active?) }
  end
end