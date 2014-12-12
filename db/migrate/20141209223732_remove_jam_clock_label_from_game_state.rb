class RemoveJamClockLabelFromGameState < ActiveRecord::Migration
  def change
    remove_column :game_states, :jam_clock_label, :string
  end
end
