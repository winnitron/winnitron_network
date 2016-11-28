class AddSlugs < ActiveRecord::Migration
  def change
    add_column :games, :slug, :string, index: true
    add_column :playlists, :slug, :string, index: true
    add_column :arcade_machines, :slug, :string, index: true

    # Game.all.each { |g| g.update(slug: g.title.parameterize) }
    # ArcadeMachine.all.each { |g| g.update(slug: g.name.parameterize) }
    # Playlist.all.each { |g| g.update(slug: g.title.parameterize) }
  end
end
