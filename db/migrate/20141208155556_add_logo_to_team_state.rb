class AddLogoToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :logo, :text
  end
end
