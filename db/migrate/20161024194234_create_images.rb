class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :parent, polymorphic: true, index: true
      t.string     :file_key
      t.datetime   :file_last_modified

      t.timestamps null: false
    end
  end
end
