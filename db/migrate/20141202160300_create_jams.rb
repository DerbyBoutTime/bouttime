class CreateJams < ActiveRecord::Migration
  def change
    create_table :jams do |t|
      t.references :game
      t.integer :number
      t.integer :period
      t.timestamps
    end
  end
end
