class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.belongs_to :game, index: true
      t.belongs_to :playlist, index: true

      t.timestamps null: false
    end
  end
end
