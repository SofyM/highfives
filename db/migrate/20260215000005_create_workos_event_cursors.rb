class CreateWorkosEventCursors < ActiveRecord::Migration[7.0]
  def change
    create_table :workos_event_cursors do |t|
      t.string :organization_id, null: false
      t.string :last_event_id
      t.timestamps
    end

    add_index :workos_event_cursors, :organization_id, unique: true
  end
end
