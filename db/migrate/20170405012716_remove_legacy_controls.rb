class RemoveLegacyControls < ActiveRecord::Migration
  def change
    remove_column :games, :legacy_controls
  end
end
