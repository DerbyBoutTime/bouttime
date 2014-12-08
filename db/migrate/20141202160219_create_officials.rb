class CreateOfficials < ActiveRecord::Migration
  def change
    create_table :officials do |t|
      t.string :certification
      t.string :league
      t.string :name

      t.timestamps
    end
  end
end
