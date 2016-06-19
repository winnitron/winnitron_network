class AddWebsiteToGames < ActiveRecord::Migration
  def change
    add_column :games, :website, :string
  end
end
