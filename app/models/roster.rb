# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  home       :boolean
#  game_id    :integer
#  team_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Roster < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  has_many :roster_skaters
  has_many :skaters, :through => :roster_skaters
end
