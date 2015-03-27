class DropIgrfTables < ActiveRecord::Migration
  def change
    drop_table :game_officials
    drop_table :games
    drop_table :interleague_game_reporting_forms
    drop_table :jams
    drop_table :lineup_skaters
    drop_table :lineups
    drop_table :officials
    drop_table :passes
    drop_table :penalties
    drop_table :roster_skaters
    drop_table :rosters
    drop_table :skaters
    drop_table :teams
    drop_table :venues
    remove_column :events, :game_id
    remove_column :game_states, :game_id
  end
end
