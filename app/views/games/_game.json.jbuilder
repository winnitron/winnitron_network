json.title           game.title
json.slug            game.slug
json.min_players     game.min_players
json.max_players     game.max_players
json.description     game.description
json.legacy_controls game.legacy_controls
json.download_url    game.download_url
json.last_modified   game.current_zip&.file_last_modified&.iso8601
json.executable      game.current_zip&.executable
json.image_url       game.cover_image.url

json.keys do
  json.template game.key_map&.template || "default"
end