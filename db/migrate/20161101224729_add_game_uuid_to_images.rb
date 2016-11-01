class AddGameUuidToImages < ActiveRecord::Migration
  def change
    rename_column :images, :uuid, :game_uuid
  end
end
