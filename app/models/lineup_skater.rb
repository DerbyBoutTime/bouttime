class LineupSkater < ActiveRecord::Base
  belongs_to :lineup
  belongs_to :skater

  has_one :penalty

  has_many :passes
end
