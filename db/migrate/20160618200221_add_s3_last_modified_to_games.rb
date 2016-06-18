class AddS3LastModifiedToGames < ActiveRecord::Migration
  def change
    add_column :games, :s3_last_modified, :datetime
  end
end
