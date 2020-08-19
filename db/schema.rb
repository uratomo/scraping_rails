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

ActiveRecord::Schema.define(version: 20200816115849) do

  create_table "addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "building_id"
    t.string   "city"
    t.string   "ward"
    t.string   "line"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["building_id"], name: "index_addresses_on_building_id", using: :btree
  end

  create_table "buildings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "suumo_number"
    t.string   "floor"
    t.integer  "area"
    t.integer  "age"
    t.integer  "structure_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["structure_id"], name: "index_buildings_on_structure_id", using: :btree
  end

  create_table "costs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "building_id"
    t.integer  "rent",               default: 0
    t.integer  "administration_fee"
    t.integer  "set_deposit",        default: 0
    t.integer  "reward",             default: 0
    t.integer  "bond_payment",       default: 0
    t.integer  "repayment",          default: 0
    t.integer  "commission",         default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["building_id"], name: "index_costs_on_building_id", using: :btree
  end

  create_table "stations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "building_id"
    t.string   "line"
    t.string   "name"
    t.integer  "walk"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["building_id"], name: "index_stations_on_building_id", using: :btree
  end

  create_table "structures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "buildings"
  add_foreign_key "costs", "buildings"
  add_foreign_key "stations", "buildings"
end
