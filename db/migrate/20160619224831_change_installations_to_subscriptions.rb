class ChangeInstallationsToSubscriptions < ActiveRecord::Migration
  def change
    drop_table :installations
    
    create_table :subscriptions do |t|
      t.belongs_to :arcade_machine
      t.belongs_to :playlist

      t.timestamps null: false
    end
  end
end
