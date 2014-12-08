class Lineup < ActiveRecord::Base
  belongs_to :jam
  belongs_to :roster

  has_many :lineup_skaters
  has_many :skaters, :through => :lineup_skaters
end
