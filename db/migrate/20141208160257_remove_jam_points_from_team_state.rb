class RemoveJamPointsFromTeamState < ActiveRecord::Migration
  def change
    remove_column :team_states, :jamPoints, :integer
  end
end
