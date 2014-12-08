class RemovePeriodClockFromGameState < ActiveRecord::Migration
  def change
    remove_column :game_states, :period_clock, :timestamp
  end
end
