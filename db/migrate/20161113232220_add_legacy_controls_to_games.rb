class AddLegacyControlsToGames < ActiveRecord::Migration
  def change
    add_column :games, :legacy_controls, :boolean, default: false
  end
end
