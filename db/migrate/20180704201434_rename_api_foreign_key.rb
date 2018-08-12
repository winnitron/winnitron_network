class RenameApiForeignKey < ActiveRecord::Migration[5.1]
  def change
    rename_column :api_keys, :arcade_machine_id, :parent_id
    add_column :api_keys, :parent_type, :string, default: "ArcadeMachine"
    add_index :api_keys, :parent_type
  end
end
