class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.references :arcade_machine
      t.references :game
      t.datetime :start
      t.datetime :stop

      t.timestamps null: false
    end
  end
end
