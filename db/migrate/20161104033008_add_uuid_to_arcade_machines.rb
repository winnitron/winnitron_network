class AddUuidToArcadeMachines < ActiveRecord::Migration
  def change
    add_column :arcade_machines, :uuid, :string
    add_index :arcade_machines, :uuid
  end
end
