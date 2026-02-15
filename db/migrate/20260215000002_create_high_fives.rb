class CreateHighFives < ActiveRecord::Migration[7.0]
  def change
    create_table :high_fives do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :giver_id, null: false
      t.timestamps
    end

    add_index :high_fives, [:user_id, :created_at]
  end
end
