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

ActiveRecord::Schema.define(version: 20160913224822) do

  create_table "campers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.date     "birthdate"
    t.string   "email"
    t.text     "medical"
    t.text     "diet_allergies"
    t.integer  "status",         default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "parent_id"
    t.index ["first_name", "last_name", "birthdate"], name: "index_campers_on_first_name_and_last_name_and_birthdate", unique: true
    t.index ["parent_id"], name: "index_campers_on_parent_id"
  end

  create_table "camps", force: :cascade do |t|
    t.integer  "year"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_camps_on_year", unique: true
  end

  create_table "parents", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "referral_methods", force: :cascade do |t|
    t.string   "name"
    t.boolean  "allow_details"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.integer  "referral_method_id"
    t.integer  "parent_id"
    t.string   "details"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["parent_id", "referral_method_id"], name: "index_referrals_on_parent_id_and_referral_method_id", unique: true
    t.index ["parent_id"], name: "index_referrals_on_parent_id"
    t.index ["referral_method_id"], name: "index_referrals_on_referral_method_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "grade"
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
