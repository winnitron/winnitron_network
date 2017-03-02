class AddPublishedAtToGames < ActiveRecord::Migration
  def up
    add_column :games, :published_at, :datetime
    add_index :games, :published_at

    Game.with_zip.select { |game| game.current_zip.executable? }.each do |game|
      game.update published_at: game.created_at
    end
  end

  def down
    remove_column :games, :published_at
  end
end
