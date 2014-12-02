class CreateJams < ActiveRecord::Migration
  def change
    create_table :jams do |t|
      t.references :game, index: true
      t.integer :number
      t.integer :period

      t.timestamps
    end
  end
end
