# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140609124018) do

  create_table "event_sets", force: true do |t|
    t.text     "attendance_users", default: "--- []\n"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "kind"
    t.integer  "event_set_id"
    t.string   "title"
    t.integer  "price"
    t.integer  "zusaar_id"
    t.text     "register_users"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nfcs", force: true do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nfcs", ["user_id"], name: "index_nfcs_on_user_id"
  add_index "nfcs", ["uuid"], name: "index_nfcs_on_uuid"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "zusaar_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
