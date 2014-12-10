class AddIsSelectedToJamState < ActiveRecord::Migration
  def change
    add_column :jam_states, :is_selected, :boolean, default: false
  end
end
