class FixLineupStatusColumnName < ActiveRecord::Migration
  def change
  	rename_column :lineup_statuses, :jam_states_id, :jam_state_id
  end
end
