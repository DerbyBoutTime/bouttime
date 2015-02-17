class CreateLineupTeamStates < ActiveRecord::Migration
  def change
    create_table :lineup_team_states do |t|
      t.boolean :no_pivot
      t.boolean :star_pass
      t.string :pivot_number
      t.string :blocker_1_number
      t.string :blocker_2_number
      t.string :blocker_3_number
      t.string :jammer_number

      t.timestamps
    end
  end
end
