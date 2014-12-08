class AddJamPointsToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :jam_points, :integer
  end
end
