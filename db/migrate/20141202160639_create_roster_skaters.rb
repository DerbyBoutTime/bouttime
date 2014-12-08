class CreateRosterSkaters < ActiveRecord::Migration
  def change
    create_table :roster_skaters do |t|
      t.references :roster, index: true
      t.references :skater, index: true

      t.timestamps
    end
  end
end
