class RemoveWebsiteFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :website
  end
end
