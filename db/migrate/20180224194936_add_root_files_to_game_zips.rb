class AddRootFilesToGameZips < ActiveRecord::Migration[5.1]
  def change
    add_column :game_zips, :root_files, :string, array: true
  end
end
