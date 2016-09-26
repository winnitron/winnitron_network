class AddPlayerCounts < ActiveRecord::Migration
  def change
    add_column :games, :min_players, :integer
    add_column :games, :max_players, :integer
  end
end
