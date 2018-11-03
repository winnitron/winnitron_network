class Api::V1::PlaylistsController < Api::V1::ApiController
  before_action :record_sync

  def index
    @playlists = @arcade_machine.approved? ? @arcade_machine.playlists : Playlist.defaults
  end

  private

  def record_sync
    LoggedEvent.create(actor: @arcade_machine, details: { user_agent: request.headers["HTTP_USER_AGENT"] })
  end
end