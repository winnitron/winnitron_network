class FixZipLastModifiedType < ActiveRecord::Migration
  def change
    remove_column :game_zips, :file_last_modified
    add_column :game_zips, :file_last_modified, :datetime
  end
end
