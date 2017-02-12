class CreateKeyMaps < ActiveRecord::Migration
  def change
    create_table :key_maps do |t|
      t.references :game
      t.integer :template, default: 0

      t.timestamps null: false
    end
  end
end
