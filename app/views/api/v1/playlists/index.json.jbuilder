json.playlists do
  json.array!(@playlists) do |playlist|

    json.title playlist.title
    json.description playlist.description
    json.slug  playlist.slug

    json.games do
      json.array!(playlist.games.published) do |game|
        json.partial! "games/game", game: game
      end
    end

  end
end