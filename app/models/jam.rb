# == Schema Information
#
# Table name: jams
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  number     :integer
#  period     :integer
#  created_at :datetime
#  updated_at :datetime
#

class Jam < ActiveRecord::Base
  belongs_to :game

  has_many :lineups
  has_many :lineup_skaters, :through => :lineups

  has_many :passes, :through => :lineup_skaters
  has_many :penalties, :through => :lineup_skaters
end
