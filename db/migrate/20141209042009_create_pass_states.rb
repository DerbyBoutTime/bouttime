class CreatePassStates < ActiveRecord::Migration
  def change
    create_table :pass_states do |t|
      t.integer :pass_number
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
