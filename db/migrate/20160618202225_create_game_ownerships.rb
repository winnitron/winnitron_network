class CreateGameOwnerships < ActiveRecord::Migration
  def change
    create_table :game_ownerships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :game, index: true

      t.timestamps null: false
    end
  end
end
