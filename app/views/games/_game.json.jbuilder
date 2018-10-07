json.title           game.title
json.slug            game.slug
json.min_players     game.min_players
json.max_players     game.max_players
json.description     game.description
json.legacy_controls game.key_map&.template == "legacy" # deprecation
json.download_url    game.download_url
json.last_modified   game.current_zip&.created_at&.iso8601
json.executable      game.current_zip&.executable
json.image_url       game.launcher_compatible_cover.url
json.local           false

json.keys do
  json.template game.key_map.template || "default"
  json.bindings game.key_map.bindings
end