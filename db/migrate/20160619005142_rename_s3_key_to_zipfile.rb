class RenameS3KeyToZipfile < ActiveRecord::Migration
  def change
    rename_column :games, :s3_key, :zipfile_key
    rename_column :games, :s3_last_modified, :zipfile_last_modified
  end
end
