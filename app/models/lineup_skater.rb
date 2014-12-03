class LineupSkater < ActiveRecord::Base
  belongs_to :lineup
  belongs_to :skater

  has_many :passes
end
