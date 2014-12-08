# == Schema Information
#
# Table name: games
#
#  id                                 :integer          not null, primary key
#  end_time                           :datetime
#  start_time                         :datetime
#  venue_id                           :integer
#  created_at                         :datetime
#  updated_at                         :datetime
#  interleague_game_reporting_form_id :integer
#

class Game < ActiveRecord::Base
  belongs_to :igrf, class_name: "InterleagueGameReportingForm"
  belongs_to :venue

  has_many :jams

  has_many :game_officials
  has_many :officials, :through => :game_officials

  has_many :rosters
end
