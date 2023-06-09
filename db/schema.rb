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

ActiveRecord::Schema[7.0].define(version: 2023_06_09_061822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attaches", force: :cascade do |t|
    t.json "path"
    t.integer "user_note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "columns", force: :cascade do |t|
    t.string "title"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "subject"
    t.text "description"
    t.datetime "event_date"
    t.integer "ringtone_id"
    t.integer "column_id"
    t.integer "note_type", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "reminder"
    t.integer "frequency"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.integer "user_id"
    t.boolean "read", default: false
    t.integer "sender_id"
    t.integer "sender_place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notif_type", default: 0
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "reward"
    t.text "terms"
    t.bigint "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "photo_product"
    t.boolean "status"
    t.integer "notes_quantity", default: 0
  end

  create_table "ringtones", force: :cascade do |t|
    t.string "name"
    t.text "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "photo"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "user_id"
    t.integer "transaction_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "point"
    t.string "point_type"
    t.bigint "user_note_id"
  end

  create_table "user_notes", force: :cascade do |t|
    t.integer "note_id"
    t.integer "user_id"
    t.integer "role", default: 0
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "noteinvitation_token"
    t.integer "noteinvitation_status"
    t.datetime "noteinvitation_expired", precision: nil
  end

  create_table "user_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "teaminvitation_token"
    t.integer "teaminvitation_status"
    t.datetime "teaminvitation_expired", precision: nil
    t.integer "team_role", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "phone"
    t.string "job"
    t.text "photo"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed"
    t.string "confirm_token"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.integer "notes_count", default: 0
  end

end
