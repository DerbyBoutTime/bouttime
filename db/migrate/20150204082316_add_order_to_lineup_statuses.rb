class AddOrderToLineupStatuses < ActiveRecord::Migration
  def change
    add_column :lineup_statuses, :order, :integer
  end
end
