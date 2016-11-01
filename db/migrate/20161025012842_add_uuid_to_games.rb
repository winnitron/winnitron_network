class AddUuidToGames < ActiveRecord::Migration
  def change
    add_column :games, :uuid, :string
    add_index :games, :uuid
  end
end
