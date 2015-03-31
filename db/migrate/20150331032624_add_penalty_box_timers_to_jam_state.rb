class AddPenaltyBoxTimersToJamState < ActiveRecord::Migration
  def change
    add_reference :jam_states, :jammer_box_state, index: true
    add_reference :jam_states, :blocker1_box_state, index: true
    add_reference :jam_states, :blocker2_box_state, index: true
  end
end
