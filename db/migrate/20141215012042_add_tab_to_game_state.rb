class AddTabToGameState < ActiveRecord::Migration
  def change
    add_column :game_states, :tab, :integer, default: 0, limit: 1
  end
end
