class AddS3KeyToGames < ActiveRecord::Migration
  def change
    add_column :games, :s3_key, :string
  end
end
