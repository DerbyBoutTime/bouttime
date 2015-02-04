class NormalizeSkaters < ActiveRecord::Migration
  def change
  	drop_table :skater_states

  	create_table :skaters do |t|
  		t.string :name
      t.string :number

      t.timestamps
    end

    create_table :rosters do |t|
      t.references :team_state, index: true
      t.references :skater, index: true
    end
  end
end
