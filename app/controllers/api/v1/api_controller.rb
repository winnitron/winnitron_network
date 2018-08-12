class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session

  respond_to :json
  before_action :token_authentication!

  private

  def token_authentication!
    auth = RequestAuthenticator.new(request, requires_signature: false)
    if auth.valid?
      @client = auth.key.parent
      @arcade_machine = @client # TODO: but maybe it's a game!
    else
      head :forbidden
    end
  end

  def signed_authentication!
    auth = RequestAuthenticator.new(request, requires_signature: true)
    if auth.valid?
      @client = auth.key.parent
      @arcade_machine = @client # TODO: but maybe it's a game!
    else
      head :forbidden
    end
  end

end
