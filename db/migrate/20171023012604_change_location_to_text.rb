class ChangeLocationToText < ActiveRecord::Migration
  def change
    change_column :arcade_machines, :location, :text
  end
end
