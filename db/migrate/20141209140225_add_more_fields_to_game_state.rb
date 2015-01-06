class AddMoreFieldsToGameState < ActiveRecord::Migration
  def change
    change_table :game_states do |t|
      t.integer :last_period_tick
      t.integer :last_jam_tick
      t.integer :period_time
      t.integer :jam_time
    end
  end
end
