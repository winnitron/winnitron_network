class AddPlayerCountToArcadeMachines < ActiveRecord::Migration
  def change
    add_column :arcade_machines, :players, :integer
  end
end
