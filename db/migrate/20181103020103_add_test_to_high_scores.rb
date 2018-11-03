class AddTestToHighScores < ActiveRecord::Migration[5.1]
  def change
    add_column :high_scores, :test, :boolean, default: false
  end
end
