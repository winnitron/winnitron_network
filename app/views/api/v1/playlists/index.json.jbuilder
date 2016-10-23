json.playlists do
  json.array!(@playlists) do |playlist|

    json.title playlist.title
    json.slug  playlist.title.parameterize

    json.games do
      json.array!(playlist.games) do |game|
        json.title         game.title
        json.slug          game.title.parameterize
        json.min_players   game.min_players
        json.max_players   game.max_players
        json.description   game.description
        json.download_url  game.download_url
        json.last_modified game.zipfile_last_modified.iso8601
      end
    end

  end
end