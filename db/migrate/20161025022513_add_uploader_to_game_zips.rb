class AddUploaderToGameZips < ActiveRecord::Migration
  def change
    add_column :game_zips, :user_id, :integer
  end
end
