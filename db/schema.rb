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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130507181925) do

  create_table "championships", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "number_of_players"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "championships", ["user_id"], :name => "index_championships_on_user_id"

  create_table "matches", :force => true do |t|
    t.integer  "championship_id"
    t.datetime "start_time"
    t.string   "location"
    t.string   "result"
    t.integer  "winner_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "matches", ["championship_id"], :name => "index_matches_on_championship_id"

  create_table "nodes", :force => true do |t|
    t.integer  "championship_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "nodes", ["championship_id"], :name => "index_nodes_on_championship_id"

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "championship_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "players", ["championship_id"], :name => "index_players_on_championship_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean  "guest",                  :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
