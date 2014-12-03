class Team < ActiveRecord::Base
  has_many :rosters
  has_many :games, :through => :rosters

  has_many :skaters
end
