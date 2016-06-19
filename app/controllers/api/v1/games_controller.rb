class Api::V1::GamesController < ApplicationController
  respond_to :json

  before_action :token_authentication!

  def index
    @playlists = @arcade_machine.playlists
    # make a jbuilder view
    respond_with({ playlists: @playlists })
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
end