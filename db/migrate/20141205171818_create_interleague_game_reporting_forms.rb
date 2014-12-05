class CreateInterleagueGameReportingForms < ActiveRecord::Migration
  def change
    create_table :interleague_game_reporting_forms do |t|
      t.string :form

      t.timestamps
    end
  end
end
