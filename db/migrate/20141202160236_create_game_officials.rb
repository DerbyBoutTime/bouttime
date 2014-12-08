class CreateGameOfficials < ActiveRecord::Migration
  def change
    create_table :game_officials do |t|
      t.references :game, index: true
      t.references :official, index: true
      t.string :position

      t.timestamps
    end
  end
end
