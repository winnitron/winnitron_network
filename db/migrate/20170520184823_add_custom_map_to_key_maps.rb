class AddCustomMapToKeyMaps < ActiveRecord::Migration
  def change
    add_column :key_maps, :custom_map, :json
  end
end
