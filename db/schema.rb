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

ActiveRecord::Schema.define(version: 20150524083736) do

  create_table "locations", force: :cascade do |t|
    t.decimal  "long"
    t.decimal  "lat"
    t.string   "timezone"
    t.integer  "post_code_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "ref_code"
  end

  add_index "locations", ["post_code_id"], name: "index_locations_on_post_code_id"

  create_table "post_codes", force: :cascade do |t|
    t.string   "num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rains", force: :cascade do |t|
    t.float    "amount"
    t.float    "prob"
    t.integer  "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rains", ["record_id"], name: "index_rains_on_record_id"

  create_table "records", force: :cascade do |t|
    t.datetime "time"
    t.string   "condition"
    t.string   "type"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "records", ["location_id"], name: "index_records_on_location_id"

  create_table "temperatures", force: :cascade do |t|
    t.float    "value"
    t.float    "dew_point"
    t.float    "prob"
    t.integer  "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "temperatures", ["record_id"], name: "index_temperatures_on_record_id"

  create_table "winds", force: :cascade do |t|
    t.string   "dir"
    t.float    "speed"
    t.float    "prob"
    t.integer  "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "winds", ["record_id"], name: "index_winds_on_record_id"

end
