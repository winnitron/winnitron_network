class AddExecToGameZips < ActiveRecord::Migration
  def change
    add_column :game_zips, :executable, :string
  end
end
