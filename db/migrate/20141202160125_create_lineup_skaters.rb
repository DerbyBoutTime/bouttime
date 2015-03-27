class CreateLineupSkaters < ActiveRecord::Migration
  def change
    create_table :lineup_skaters do |t|
      t.references :lineup, index: true
      t.references :skater, index: true
      t.string :role
      t.timestamps
    end
  end
end
