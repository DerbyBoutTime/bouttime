class Skater < ActiveRecord::Base
  belongs_to :team

  has_many :lineup_skaters
  has_many :lineups, :through => :lineup_skaters
  has_many :penalties, :through => :lineup_skaters

  has_many :roster_skaters
  has_many :rosters, :through => :roster_skaters
end
