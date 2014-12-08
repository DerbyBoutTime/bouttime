class CreateTeamStates < ActiveRecord::Migration
  def change
    create_table :team_states do |t|
      t.string :name
      t.string :initials
      t.text :color_bar_style
      t.integer :points
      t.integer :jamPoints
      t.boolean :is_taking_official_review
      t.boolean :is_taking_timeout
      t.integer :timeouts
      t.references :jammer, index: true

      t.timestamps
    end
  end
end
