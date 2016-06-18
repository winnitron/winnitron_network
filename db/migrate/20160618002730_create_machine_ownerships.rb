class CreateMachineOwnerships < ActiveRecord::Migration
  def change
    create_table :machine_ownerships do |t|

      t.belongs_to :user, index: true
      t.belongs_to :arcade_machine, index: true
      
      t.timestamps null: false
    end
  end
end
