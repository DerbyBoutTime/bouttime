class AddSortToPassStates < ActiveRecord::Migration
  def change
    add_column :pass_states, :sort, :integer
  end
end
