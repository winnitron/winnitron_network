class RemoveBuilderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :builder
  end
end
