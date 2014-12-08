class Roster < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  has_many :roster_skaters
  has_many :skaters, :through => :roster_skaters
end
