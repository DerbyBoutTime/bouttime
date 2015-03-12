class CreateSkaterStates < ActiveRecord::Migration
  def change
    create_table :skater_states do |t|
      t.string :name
      t.string :number
      t.references :team_state, index: true

      t.timestamps
    end
  end
end
