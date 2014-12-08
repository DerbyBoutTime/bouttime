class CreateJammerStates < ActiveRecord::Migration
  def change
    create_table :jammer_states do |t|
      t.string :name
      t.string :number
      t.boolean :is_lead

      t.timestamps
    end
  end
end
