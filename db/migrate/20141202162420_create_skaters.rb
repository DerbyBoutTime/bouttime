class CreateSkaters < ActiveRecord::Migration
  def change
    create_table :skaters do |t|
      t.references :team, index: true
      t.string :name
      t.string :number

      t.timestamps
    end
  end
end
