class CreatePenaltyStates < ActiveRecord::Migration
  def change
    create_table :penalty_states do |t|
      t.references :skater_state, index: true
      t.references :penalty, index: true
      t.integer :sort
      t.integer :jam_number

      t.timestamps
    end
  end
end
