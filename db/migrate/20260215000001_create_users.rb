class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :workos_id, null: false
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :organization_id
      t.string :connection_id

      t.timestamps
    end

    add_index :users, :workos_id, unique: true
    add_index :users, :email
  end
end
