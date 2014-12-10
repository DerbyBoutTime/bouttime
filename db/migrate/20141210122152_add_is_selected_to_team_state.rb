class AddIsSelectedToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :is_selected, :boolean, default: false
  end
end
