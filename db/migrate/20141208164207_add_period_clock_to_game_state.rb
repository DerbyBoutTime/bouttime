class AddPeriodClockToGameState < ActiveRecord::Migration
  def change
    add_column :game_states, :period_clock, :integer
  end
end
