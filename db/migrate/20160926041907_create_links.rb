class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :parent, polymorphic: true, index: true
      t.string     :url
      t.string     :link_type

      t.timestamps null: false
    end
  end
end
