class AddBuilderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :builder, :boolean, default: false
  end
end
