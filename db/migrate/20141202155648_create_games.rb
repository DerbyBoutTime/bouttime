class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.timestamp :end_time
      t.timestamp :start_time

      t.references :venue, index: true

      t.timestamps
    end
  end
end
