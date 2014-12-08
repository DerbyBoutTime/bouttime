class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.references :lineup_skater, index: true
      t.string :code

      t.timestamps
    end
  end
end
