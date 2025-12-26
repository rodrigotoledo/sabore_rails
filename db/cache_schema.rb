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

ActiveRecord::Schema[8.1].define(version: 2025_12_25_210338) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "categories_establishments", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.integer "establishment_id", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categories_establishments_on_category_id"
    t.index ["establishment_id"], name: "index_categories_establishments_on_establishment_id"
  end

  create_table "establishments", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "establishment_type"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "name"
    t.string "phone"
    t.decimal "rating"
    t.datetime "updated_at", null: false
  end

  create_table "menu_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "establishment_id", null: false
    t.string "name"
    t.string "photo"
    t.decimal "price"
    t.datetime "updated_at", null: false
    t.index ["establishment_id"], name: "index_menu_items_on_establishment_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date"
    t.string "email"
    t.integer "establishment_id", null: false
    t.integer "people_count"
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["establishment_id"], name: "index_reservations_on_establishment_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", limit: 4, null: false
    t.datetime "created_at", null: false
    t.binary "key", limit: 1024, null: false
    t.integer "key_hash", limit: 8, null: false
    t.binary "value", limit: 536870912, null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories_establishments", "categories"
  add_foreign_key "categories_establishments", "establishments"
  add_foreign_key "menu_items", "establishments"
  add_foreign_key "reservations", "establishments"
  add_foreign_key "reservations", "users"
  add_foreign_key "sessions", "users"
end
