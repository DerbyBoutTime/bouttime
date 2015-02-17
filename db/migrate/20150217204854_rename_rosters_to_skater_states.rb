class RenameRostersToSkaterStates < ActiveRecord::Migration
  def change
  	rename_table :rosters, :skater_states
  end
end
