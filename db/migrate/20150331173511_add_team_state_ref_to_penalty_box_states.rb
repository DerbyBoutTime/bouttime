class AddTeamStateRefToPenaltyBoxStates < ActiveRecord::Migration
  def change
    add_reference :penalty_box_states, :team_state, index: true
  end
end
