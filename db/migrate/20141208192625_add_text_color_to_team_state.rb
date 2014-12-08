class AddTextColorToTeamState < ActiveRecord::Migration
  def change
    add_column :team_states, :text_color, :string
  end
end
