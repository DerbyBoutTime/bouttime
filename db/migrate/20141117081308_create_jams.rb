class CreateJams < ActiveRecord::Migration
  def change
    create_table :jams do |t|
      t.integer :period
      t.integer :number
      t.timestamp :started
      t.timestamp :finished

      t.timestamps
    end
  end
end
