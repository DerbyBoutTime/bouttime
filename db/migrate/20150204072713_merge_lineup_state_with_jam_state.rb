class MergeLineupStateWithJamState < ActiveRecord::Migration
  def change
  	drop_table :lineup_states
  	drop_table :lineup_team_states
  	drop_table :lineup_status_states

  	add_column :jam_states, :no_pivot, :boolean
  	add_column :jam_states, :star_pass, :boolean
  	add_reference :jam_states, :pivot, index: true
  	add_reference :jam_states, :blocker1, index: true
  	add_reference :jam_states, :blocker2, index: true
  	add_reference :jam_states, :blocker3, index: true
  	add_reference :jam_states, :jammer, index: true

  	create_table :lineup_statuses do |t|
  		t.string :pivot
      t.string :blocker1
      t.string :blocker2
      t.string :blocker3
      t.string :jammer
      t.references :jam_states, index: true

      t.timestamps
    end
  end
end
