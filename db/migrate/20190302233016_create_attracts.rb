class CreateAttracts < ActiveRecord::Migration[5.2]
  def change
    create_table :attracts do |t|
      t.references :arcade_machine, index: true
      t.text :text
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps null: false
    end
  end
end
