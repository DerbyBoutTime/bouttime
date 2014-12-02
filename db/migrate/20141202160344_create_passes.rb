class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.references :jam, index: true
      t.references :lineup_skater, index: true
      t.integer :score

      t.timestamps
    end
  end
end
