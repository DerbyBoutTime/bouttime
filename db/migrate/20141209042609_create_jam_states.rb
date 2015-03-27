class CreateJamStates < ActiveRecord::Migration
  def change
    create_table :jam_states do |t|
      t.references :team_state, index: true
      t.integer :jam_number
      t.string :skater_number
      t.integer :points
      t.boolean :injury
      t.boolean :lead
      t.boolean :lost_lead
      t.boolean :calloff
      t.boolean :nopass
      t.timestamps
    end
  end
end
