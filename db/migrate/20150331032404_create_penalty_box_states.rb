class CreatePenaltyBoxStates < ActiveRecord::Migration
  def change
    create_table :penalty_box_states do |t|
      t.belongs_to :skater, index: true
      t.boolean :left_early
      t.boolean :served
      t.belongs_to :clock_state, index: true

      t.timestamps
    end
  end
end
