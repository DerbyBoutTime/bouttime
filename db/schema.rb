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

ActiveRecord::Schema.define(version: 20141202162420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_officials", force: true do |t|
    t.integer  "game_id"
    t.integer  "official_id"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_officials", ["game_id"], name: "index_game_officials_on_game_id", using: :btree
  add_index "game_officials", ["official_id"], name: "index_game_officials_on_official_id", using: :btree

  create_table "games", force: true do |t|
    t.datetime "end_time"
    t.datetime "start_time"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["venue_id"], name: "index_games_on_venue_id", using: :btree

  create_table "jams", force: true do |t|
    t.integer  "game_id"
    t.integer  "number"
    t.integer  "period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jams", ["game_id"], name: "index_jams_on_game_id", using: :btree

  create_table "lineup_skaters", force: true do |t|
    t.integer  "lineup_id"
    t.integer  "skater_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lineup_skaters", ["lineup_id"], name: "index_lineup_skaters_on_lineup_id", using: :btree
  add_index "lineup_skaters", ["skater_id"], name: "index_lineup_skaters_on_skater_id", using: :btree

  create_table "lineups", force: true do |t|
    t.integer  "jam_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lineups", ["jam_id"], name: "index_lineups_on_jam_id", using: :btree

  create_table "officials", force: true do |t|
    t.string   "certification"
    t.string   "league"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passes", force: true do |t|
    t.integer  "jam_id"
    t.integer  "lineup_skater_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "passes", ["jam_id"], name: "index_passes_on_jam_id", using: :btree
  add_index "passes", ["lineup_skater_id"], name: "index_passes_on_lineup_skater_id", using: :btree

  create_table "penalties", force: true do |t|
    t.integer  "jam_id"
    t.integer  "skater_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "penalties", ["jam_id"], name: "index_penalties_on_jam_id", using: :btree
  add_index "penalties", ["skater_id"], name: "index_penalties_on_skater_id", using: :btree

  create_table "roster_skaters", force: true do |t|
    t.integer  "roster_id"
    t.integer  "skater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roster_skaters", ["roster_id"], name: "index_roster_skaters_on_roster_id", using: :btree
  add_index "roster_skaters", ["skater_id"], name: "index_roster_skaters_on_skater_id", using: :btree

  create_table "rosters", force: true do |t|
    t.integer  "game_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rosters", ["game_id"], name: "index_rosters_on_game_id", using: :btree
  add_index "rosters", ["team_id"], name: "index_rosters_on_team_id", using: :btree

  create_table "skaters", force: true do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skaters", ["team_id"], name: "index_skaters_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "venues", force: true do |t|
    t.string   "city"
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
