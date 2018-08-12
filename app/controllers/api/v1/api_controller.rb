class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json
  before_action :token_authentication!

  private

  def token_authentication!
    auth = RequestAuthenticator.new(request, requires_signature: false)
    if auth.valid?
      set_client(auth)
    else
      render json: { errors: ["Invalid API key."] }, status: :forbidden
    end
  end

  def signed_authentication!
    auth = RequestAuthenticator.new(request, requires_signature: true)
    if auth.valid?
      set_client(auth)
    else
      render json: { errors: ["Invalid API key or signature."] }, status: :forbidden
    end
  end

  def set_client(auth)
    client = auth.key.parent
    if client.is_a?(ArcadeMachine)
      @arcade_machine = client
    elsif client.is_a?(Game)
      @game = client
    end
  end
end
