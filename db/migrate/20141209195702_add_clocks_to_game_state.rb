class AddClocksToGameState < ActiveRecord::Migration
  def change
    change_table :game_states do |t|
      t.remove :jam_clock
      t.remove :period_clock
      t.remove :last_period_tick
      t.remove :last_jam_tick
      t.remove :period_time
      t.remove :jam_time
      t.references :jam_clock
      t.references :period_clock
    end
  end
end