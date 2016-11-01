class AddUuidAndUserToImages < ActiveRecord::Migration
  def change
    add_column :images, :uuid, :string
    add_index :images, :uuid

    add_column :images, :user_id, :integer
    add_index :images, :user_id
  end
end
