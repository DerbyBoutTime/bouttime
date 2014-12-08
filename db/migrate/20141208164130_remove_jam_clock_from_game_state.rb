class RemoveJamClockFromGameState < ActiveRecord::Migration
  def change
    remove_column :game_states, :jam_clock, :timestamp
  end
end
