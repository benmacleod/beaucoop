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

ActiveRecord::Schema.define(version: 20140301090748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "books", force: true do |t|
    t.text     "title"
    t.text     "author"
    t.text     "publisher"
    t.text     "edition"
    t.text     "category"
    t.text     "subject"
    t.string   "condition"
    t.string   "isbn"
    t.integer  "price_cents",      default: 0,     null: false
    t.string   "price_currency",   default: "USD", null: false
    t.boolean  "in_shop"
    t.integer  "user_id"
    t.datetime "consignment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "checked"
    t.string   "genre"
    t.text     "consignee"
    t.text     "thumbnail"
    t.text     "description"
    t.boolean  "price_negotiable"
    t.date     "expiry_date"
    t.date     "warned_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.text     "contact_details"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "phone_number"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "direct_email"
    t.text     "contact_details"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
