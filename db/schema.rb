# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_02_15_000005) do
  create_table "high_fives", force: :cascade do |t|
    t.integer "user_id", null: false
    t.bigint "giver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "created_at"], name: "index_high_fives_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_high_fives_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "workos_id", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "organization_id"
    t.string "connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "directory_user_id"
    t.string "directory_id"
    t.string "directory_state"
    t.string "team"
    t.index ["directory_user_id"], name: "index_users_on_directory_user_id", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["workos_id"], name: "index_users_on_workos_id", unique: true
  end

  create_table "workos_event_cursors", force: :cascade do |t|
    t.string "organization_id", null: false
    t.string "last_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_workos_event_cursors_on_organization_id", unique: true
  end

  add_foreign_key "high_fives", "users"
end
