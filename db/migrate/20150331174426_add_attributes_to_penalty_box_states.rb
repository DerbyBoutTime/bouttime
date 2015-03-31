class AddAttributesToPenaltyBoxStates < ActiveRecord::Migration
  def change
    add_column :penalty_box_states, :sat_in_jam, :integer
    add_column :penalty_box_states, :position, :string
    add_column :penalty_box_states, :sat_time_remaining, :integer
    add_column :penalty_box_states, :warn_time_remaining, :integer
    add_column :penalty_box_states, :release_time_remaining, :integer
    add_column :penalty_box_states, :jam_end_time_remaining, :integer
  end
end
