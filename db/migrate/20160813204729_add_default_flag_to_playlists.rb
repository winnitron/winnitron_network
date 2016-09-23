class AddDefaultFlagToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :default, :boolean, default: false
  end
end
