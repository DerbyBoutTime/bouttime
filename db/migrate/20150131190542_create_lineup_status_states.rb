class CreateLineupStatusStates < ActiveRecord::Migration
  def change
    create_table :lineup_status_states do |t|
      t.string :pivot
      t.string :blocker_1
      t.string :blocker_2
      t.string :blocker_3
      t.string :jammer
      t.references :lineup_team_state, index: true
      t.timestamps
    end
  end
end
