class AddColorToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :color, :string
  end
end
