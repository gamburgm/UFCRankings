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

ActiveRecord::Schema.define(version: 20190922210026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "href"
  end

  create_table "fighters", force: :cascade do |t|
    t.date "debut"
    t.integer "wins", default: 0
    t.integer "losses", default: 0
    t.integer "draws", default: 0
    t.boolean "active", default: false
    t.integer "age"
    t.decimal "height"
    t.decimal "reach"
    t.decimal "elo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "href"
    t.string "name"
    t.index ["href"], name: "index_fighters_on_href", unique: true
  end

  create_table "fights", force: :cascade do |t|
    t.date "date"
    t.integer "event_id"
    t.integer "first_fighter_id"
    t.integer "second_fighter_id"
    t.integer "weight_class_id"
    t.integer "victor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fight_id"
  end

  create_table "weight_classes", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fights", "events"
  add_foreign_key "fights", "fighters", column: "first_fighter_id"
  add_foreign_key "fights", "fighters", column: "second_fighter_id"
  add_foreign_key "fights", "fighters", column: "victor_id"
  add_foreign_key "fights", "weight_classes"
end
