class CreateJams < ActiveRecord::Migration
  def change
    create_table :jams do |t|
      t.integer :period
      t.integer :number
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps
    end
  end
end
