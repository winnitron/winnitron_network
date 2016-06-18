class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|

      t.belongs_to :arcade_machine, index: true
      t.string     :token, index: true

      t.timestamps null: false
    end
  end
end
