class LineupSkater < ActiveRecord::Base
  belongs_to :lineup
  belongs_to :skater
end
