class RenameImagesUuidAgain < ActiveRecord::Migration
  def change
    rename_column :images, :game_uuid, :parent_uuid
  end
end
