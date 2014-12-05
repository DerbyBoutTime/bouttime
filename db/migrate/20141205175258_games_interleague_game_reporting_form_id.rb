class GamesInterleagueGameReportingFormId < ActiveRecord::Migration
  def change
    change_table :games do |table|
      table.references :interleague_game_reporting_form
    end
  end
end
