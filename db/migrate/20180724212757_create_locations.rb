class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|

      t.integer :parent_id
      t.string  :parent_type
      t.string  :address
      t.string  :city
      t.string  :state
      t.string  :country
      t.float   :latitude
      t.float   :longitude

      t.timestamps null: false

    end
  end
end
