class CreateGameStates < ActiveRecord::Migration
  def change
    create_table :game_states do |t|
      t.integer :state
      t.integer :jam_number
      t.integer :period_number
      t.string :jam_clock_label
      t.timestamp :jam_clock
      t.timestamp :period_clock
      t.references :home, index: true
      t.references :away, index: true
      t.references :game, index: true

      t.timestamps
    end
  end
end
