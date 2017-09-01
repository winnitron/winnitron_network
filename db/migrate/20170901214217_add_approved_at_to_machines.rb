class AddApprovedAtToMachines < ActiveRecord::Migration
  def change
    add_column :arcade_machines, :approved_at, :datetime
  end
end
