class CreateGameZips < ActiveRecord::Migration
  def change
    create_table :game_zips do |t|
      t.references :game
      t.string :game_uuid, index: true
      t.string :file_key
      t.string :file_last_modified
      t.timestamps null: false
    end
  end
end
