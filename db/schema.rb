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

ActiveRecord::Schema.define(version: 20160315155207) do

  create_table "bases", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pizzas", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "description", null: false
    t.decimal  "price",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "base_id", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",                      null: false 
    t.boolean  "paid",         default: false, null: false
    t.boolean  "discontinued", default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "ordered_for",                  null: false 
    t.datetime "payment_date"
    t.integer  "flag",         default: false   
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id",                     null: false 
    t.integer  "pizza_id",                     null: false 
    t.integer  "base_id",                      null: false 
  end

  add_index "order_items", ["pizza_id"], name: "index_order_items_on_pizza_id"
  add_index "order_items", ["base_id"], name: "index_order_items_on_base_id"
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id"


  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "last_token"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "promo"
  end

  create_table "order_end_days", force: :cascade do |t|
    t.datetime "end_day",            null: false
    t.datetime "deliver_date",       null: false
  end

end
