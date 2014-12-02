class CreateRosters < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.references :game, index: true
      t.references :team, index: true

      t.timestamps
    end
  end
end
