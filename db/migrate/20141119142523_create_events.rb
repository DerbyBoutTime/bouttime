class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.json :data
      t.references :game, index: true
      t.timestamps
    end
  end
end
