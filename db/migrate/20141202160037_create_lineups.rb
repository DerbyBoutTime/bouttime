class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.references :jam, index: true
      t.references :roster, index: true
      t.timestamps
    end
  end
end
