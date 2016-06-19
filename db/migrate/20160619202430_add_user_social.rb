class AddUserSocial < ActiveRecord::Migration
  def change
    add_column :users, :twitter_username, :string
    add_column :users, :website, :string
  end
end
