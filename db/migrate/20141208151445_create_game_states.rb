class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :state, limit: 1
      t.integer :jam_number, limit: 1
      t.integer :period_number, limit: 1
      t.string :jam_clock_label, limit: 64
      t.timestamp :jam_clock
      t.timestamp :period_clock
      t.references :home, index: true
      t.references :away, index: true
      t.references :game, index: true
      t.timestamps
    end
  end
end
