class CreateHighScores < ActiveRecord::Migration[5.1]
  def change
    create_table :high_scores do |t|
      t.string :name
      t.integer :score

      t.references :game
      t.references :arcade_machine

      t.json :extras

      t.timestamps null: false
    end
  end
end
