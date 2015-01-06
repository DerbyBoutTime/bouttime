class AddTickToClockState < ActiveRecord::Migration
  def change
    add_column :clock_states, :tick, :timestamp
  end
end
