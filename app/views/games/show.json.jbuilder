json.game do
  json.title         @game.title
  json.slug          @game.title.parameterize
  json.description   @game.description
  json.download_url  @game.download_url
  json.last_modified @game.zipfile_last_modified.iso8601
  json.link          game_url(@game)
end