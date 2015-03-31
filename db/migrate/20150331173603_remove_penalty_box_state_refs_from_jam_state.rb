class RemovePenaltyBoxStateRefsFromJamState < ActiveRecord::Migration
  def change
    remove_reference :jam_states, :jammer_box_state
    remove_reference :jam_states, :blocker1_box_state
    remove_reference :jam_states, :blocker2_box_state
  end
end
