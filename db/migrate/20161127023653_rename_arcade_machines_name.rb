class RenameArcadeMachinesName < ActiveRecord::Migration
  def change
    rename_column :arcade_machines, :name, :title
  end
end
