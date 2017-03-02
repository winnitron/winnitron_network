class RemoveUuids < ActiveRecord::Migration
  def change
    remove_column :games, :uuid
    remove_column :arcade_machines, :uuid
    remove_column :images, :parent_uuid
    remove_column :game_zips, :game_uuid
  end
end
