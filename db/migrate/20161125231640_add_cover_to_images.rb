class AddCoverToImages < ActiveRecord::Migration
  def change
    add_column :images, :cover, :boolean, default: false
  end
end
