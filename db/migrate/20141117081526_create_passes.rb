class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
      t.references :jam, index: true

      t.timestamps
    end
  end
end
