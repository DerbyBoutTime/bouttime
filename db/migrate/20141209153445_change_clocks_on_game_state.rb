class ChangeClocksOnGameState < ActiveRecord::Migration
  def up
    change_table :game_states do |t|
      t.change :jam_clock, :string, length: 16
      t.change :period_clock, :string, length: 16
    end
  end
  def down
    change_table :game_states do |t|
      t.change :jam_clock, :integer
      t.change :period_clock, :integer
    end
  end
end
