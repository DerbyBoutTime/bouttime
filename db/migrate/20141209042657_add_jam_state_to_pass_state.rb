class AddJamStateToPassState < ActiveRecord::Migration
  def change
    add_reference :pass_states, :jam_state, index: true
  end
end
