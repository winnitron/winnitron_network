class DropLegacyLocations < ActiveRecord::Migration[5.1]
  def change
    remove_column :arcade_machines, :legacy_location
    remove_column :arcade_machines, :latitude
    remove_column :arcade_machines, :longitude
  end
end
