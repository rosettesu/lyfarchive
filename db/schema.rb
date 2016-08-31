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

ActiveRecord::Schema.define(version: 20160830002124) do

  create_table "campers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.date     "birthdate"
    t.string   "email"
    t.text     "medical"
    t.text     "diet_allergies"
    t.boolean  "active"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "parent_id"
    t.index ["first_name", "last_name", "birthdate"], name: "index_campers_on_first_name_and_last_name_and_birthdate", unique: true
    t.index ["parent_id"], name: "index_campers_on_parent_id"
  end

  create_table "camps", force: :cascade do |t|
    t.integer  "year"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_camps_on_year"
  end

  create_table "parents", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "referral_method"
    t.string   "referred_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "grade_completed"
    t.integer  "shirt_size"
    t.boolean  "bus"
    t.text     "additional_notes"
    t.string   "waiver_signature"
    t.datetime "waiver_date"
    t.integer  "group"
    t.string   "family"
    t.string   "cabin"
    t.integer  "camp_id"
    t.integer  "camper_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["camp_id", "camper_id"], name: "index_registrations_on_camp_id_and_camper_id", unique: true
    t.index ["camp_id"], name: "index_registrations_on_camp_id"
    t.index ["camper_id"], name: "index_registrations_on_camper_id"
  end

end
