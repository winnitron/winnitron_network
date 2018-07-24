class TmpLocation < ActiveRecord::Migration[5.1]
  def change
    rename_column :arcade_machines, :location, :legacy_location
  end
end
