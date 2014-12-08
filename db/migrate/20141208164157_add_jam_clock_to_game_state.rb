class AddJamClockToGameState < ActiveRecord::Migration
  def change
    add_column :game_states, :jam_clock, :integer
  end
end
