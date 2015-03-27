class CreateLineupStates < ActiveRecord::Migration
  def change
    create_table :lineup_states do |t|
      t.integer :jam_number
      t.boolean :jam_ended
      t.references :game_state, index: true
      t.references :home_state, index: true
      t.references :away_state, index: true
      t.timestamps
    end
  end
end
