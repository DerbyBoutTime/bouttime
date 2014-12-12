class CreateClockStates < ActiveRecord::Migration
  def change
    create_table :clock_states do |t|
      t.string :display, limit: 16
      t.integer :time
      t.integer :offset, limit: 2
      t.timestamps
    end
  end
end
