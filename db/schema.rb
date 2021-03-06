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

ActiveRecord::Schema.define(version: 2022_07_03_143031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_customer_id"
    t.integer "status", default: 0, null: false
    t.datetime "trial_end_date", default: -> { "(now() + 'P14D'::interval)" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "key_value"
    t.bigint "map_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["key_value"], name: "index_api_keys_on_key_value", unique: true
    t.index ["map_id"], name: "index_api_keys_on_map_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "address"
    t.decimal "latitude", precision: 15, scale: 10
    t.decimal "longitude", precision: 15, scale: 10
    t.bigint "map_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["map_id"], name: "index_locations_on_map_id"
  end

  create_table "maps", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "sync_mode", default: false, null: false
    t.index ["user_id"], name: "index_maps_on_user_id"
  end

  create_table "opening_times", force: :cascade do |t|
    t.integer "day", null: false
    t.time "opens_at"
    t.time "closes_at"
    t.boolean "open_24h", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "location_id"
    t.boolean "closed", default: false, null: false
    t.index ["day", "location_id"], name: "index_opening_times_on_day_and_location_id", unique: true
    t.index ["location_id"], name: "index_opening_times_on_location_id"
  end

  create_table "sync_payload_dumps", force: :cascade do |t|
    t.jsonb "payload"
    t.integer "processing_status", null: false
    t.bigint "map_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["map_id"], name: "index_sync_payload_dumps_on_map_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "api_keys", "maps"
  add_foreign_key "locations", "maps"
  add_foreign_key "maps", "users"
  add_foreign_key "opening_times", "locations"
  add_foreign_key "sync_payload_dumps", "maps"
end
