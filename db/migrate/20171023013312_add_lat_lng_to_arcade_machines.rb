class AddLatLngToArcadeMachines < ActiveRecord::Migration
  def change
    add_column :arcade_machines, :latitude, :float
    add_column :arcade_machines, :longitude, :float
    add_column :arcade_machines, :mappable, :boolean, default: true
  end
end
