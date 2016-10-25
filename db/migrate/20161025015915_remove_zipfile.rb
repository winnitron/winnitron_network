class RemoveZipfile < ActiveRecord::Migration
  def change
    remove_column :games, :zipfile_key
    remove_column :games, :zipfile_last_modified
  end
end
