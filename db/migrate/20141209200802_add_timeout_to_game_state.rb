class AddTimeoutToGameState < ActiveRecord::Migration
  def change
    add_column :game_states, :timeout, :integer, limit: 1
  end
end
