class RenameHighScoresTestToSandbox < ActiveRecord::Migration[5.1]
  def change
    rename_column :high_scores, :test, :sandbox
  end
end
