class AddDirectorySyncFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :directory_user_id, :string
    add_column :users, :directory_id, :string
    add_column :users, :directory_state, :string
    add_index :users, :directory_user_id, unique: true
  end
end
