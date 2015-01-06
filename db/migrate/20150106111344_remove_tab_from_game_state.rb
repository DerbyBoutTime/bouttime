class RemoveTabFromGameState < ActiveRecord::Migration
  def change
    remove_column :game_states, :tab
  end
end
