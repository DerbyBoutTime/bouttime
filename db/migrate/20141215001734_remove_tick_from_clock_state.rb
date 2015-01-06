class RemoveTickFromClockState < ActiveRecord::Migration
  def change
    remove_column :clock_states, :tick, :timestamp
    remove_column :clock_states, :time, :timestamp
    add_column :clock_states, :time, :integer
  end
end
