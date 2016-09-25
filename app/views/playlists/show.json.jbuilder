json.playlist do
  json.title @playlist.title
  json.link  playlist_url(@playlist)
end