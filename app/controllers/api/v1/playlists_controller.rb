class Api::V1::PlaylistsController < ApplicationController
  respond_to :json

  before_action :token_authentication!
  before_action :record_sync

  def index
    @playlists = @arcade_machine.playlists
  end

  private

  def token_authentication!
    auth_header = request.headers["Authorization"]
    token = if auth_header && auth_header.starts_with?("Token")
      auth_header.split(" ").last
    else
      params[:api_key]
    end

    if !(key = ApiKey.find_by(token: token))
      head :forbidden
    else
      @arcade_machine = key.arcade_machine
    end
  end

  def record_sync
    LoggedEvent.create(actor: @arcade_machine, details: { user_agent: request.headers["HTTP_USER_AGENT"] })
  end
end