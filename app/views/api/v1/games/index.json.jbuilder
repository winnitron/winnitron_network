json.games do
  json.array!(@games) do |game|
    json.title        game.title
    json.description  game.description
    json.download_url game.download_url
  end
end