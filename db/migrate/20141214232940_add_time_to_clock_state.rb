class AddTimeToClockState < ActiveRecord::Migration
  def change
    remove_column :clock_states, :time, :integer
    remove_column :clock_states, :offset, :integer
    add_column :clock_states, :time, :timestamp
  end
end
