class CreateNewPenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.string :name
      t.string :code
      t.integer :sort

      t.timestamps
    end
  end
end
