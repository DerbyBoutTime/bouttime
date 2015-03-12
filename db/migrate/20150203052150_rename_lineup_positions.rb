class RenameLineupPositions < ActiveRecord::Migration
  def change
  	rename_column :lineup_team_states, :blocker_1_number, :blocker1_number
  	rename_column :lineup_team_states, :blocker_2_number, :blocker2_number
  	rename_column :lineup_team_states, :blocker_3_number, :blocker3_number
  	rename_column :lineup_status_states, :blocker_1, :blocker1
  	rename_column :lineup_status_states, :blocker_2, :blocker2
  	rename_column :lineup_status_states, :blocker_3, :blocker3
  end
end
