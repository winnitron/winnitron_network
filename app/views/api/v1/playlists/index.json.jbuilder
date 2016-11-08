json.playlists do
  json.array!(@playlists) do |playlist|

    json.title playlist.title
    json.slug  playlist.title.parameterize

    json.games do
      json.array!(playlist.games.with_zip) do |game|
        json.partial! "games/game", game: game
      end
    end

  end
end