class AddIsSelectedToPassState < ActiveRecord::Migration
  def change
    add_column :pass_states, :is_selected, :boolean, default: false
  end
end
