class AddSecretToApiKeys < ActiveRecord::Migration[5.1]
  def change
    add_column :api_keys, :secret, :string
  end
end
