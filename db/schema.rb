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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110529110608) do

  create_table "achievements", :force => true do |t|
    t.integer "user_id"
    t.string  "token"
    t.integer "source_id"
    t.string  "source_type"
  end

  create_table "exercise_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "exercise_id"
    t.float    "energy",       :null => false
    t.datetime "exercised_at", :null => false
    t.float    "distance"
    t.integer  "hours"
    t.integer  "minutes"
    t.integer  "seconds"
  end

  create_table "exercises", :force => true do |t|
    t.string "name", :limit => 50, :null => false
    t.float  "met",                :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer "user_id"
    t.integer "favorable_id"
    t.string  "favorable_type"
  end

  create_table "food_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "consumable_id"
    t.string   "consumable_type"
    t.float    "value"
    t.string   "unit",            :limit => 50
    t.datetime "eaten_at",                      :null => false
    t.float    "energy"
    t.float    "protein"
    t.float    "carbs"
    t.float    "fat"
  end

  add_index "food_entries", ["eaten_at"], :name => "index_food_entries_on_eaten_at"

  create_table "food_units", :force => true do |t|
    t.string  "ancestry"
    t.float   "value"
    t.string  "unit"
    t.float   "parent_value"
    t.string  "parent_unit"
    t.integer "consumable_id",   :null => false
    t.string  "consumable_type", :null => false
    t.float   "energy"
    t.float   "protein"
    t.float   "carbs"
    t.float   "fat"
  end

  add_index "food_units", ["ancestry"], :name => "index_food_units_on_ancestry"

  create_table "products", :force => true do |t|
    t.string  "name",    :null => false
    t.integer "user_id", :null => false
  end

  create_table "tracker_entries", :force => true do |t|
    t.float    "value",      :null => false
    t.integer  "user_id",    :null => false
    t.integer  "tracker_id", :null => false
    t.datetime "logged_on",  :null => false
    t.string   "unit",       :null => false
  end

  create_table "trackers", :force => true do |t|
    t.string  "name",        :null => false
    t.boolean "private",     :null => false
    t.integer "user_id"
    t.string  "custom_unit"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",         :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",         :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.date     "birthday"
    t.boolean  "gender"
    t.float    "weight_change_rate",                  :default => 0.0
    t.string   "time_zone",                           :default => "Helsinki"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
