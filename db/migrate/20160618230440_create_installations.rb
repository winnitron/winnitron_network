class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.belongs_to :game, index: true
      t.belongs_to :arcade_machine, index: true

      t.timestamps null: false
    end
  end
end
