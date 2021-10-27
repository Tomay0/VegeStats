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

ActiveRecord::Schema.define(version: 2021_10_27_081810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "channels", id: false, force: :cascade do |t|
    t.bigint "id"
    t.bigint "guild_id"
    t.text "channel_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id"], name: "index_channels_on_id", unique: true
  end

  create_table "guilds", id: false, force: :cascade do |t|
    t.bigint "id"
    t.string "guild_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id"], name: "index_guilds_on_id", unique: true
  end

  create_table "messages", id: false, force: :cascade do |t|
    t.bigint "id"
    t.bigint "guild_id"
    t.bigint "channel_id"
    t.bigint "user_id"
    t.text "message"
    t.datetime "message_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id"], name: "index_messages_on_id", unique: true
  end

  create_table "users", id: false, force: :cascade do |t|
    t.bigint "id"
    t.text "user_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id"], name: "index_users_on_id", unique: true
  end

  add_foreign_key "channels", "guilds"
  add_foreign_key "messages", "channels"
  add_foreign_key "messages", "guilds"
  add_foreign_key "messages", "users"
end
