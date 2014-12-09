class AddNameToEvent < ActiveRecord::Migration
  def change
    add_column :events, :name, :string
  end
end
