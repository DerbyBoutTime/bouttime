class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.boolean :home

      t.references :game, index: true
      t.references :team, index: true

      t.timestamps
    end
  end
end
