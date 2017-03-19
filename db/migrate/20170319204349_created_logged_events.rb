class CreatedLoggedEvents < ActiveRecord::Migration
  def change
    create_table :logged_events do |t|
      t.references :actor, polymorphic: true, index: true
      t.json       :details

      t.timestamps null: false
    end
  end
end
