class RosterSkater < ActiveRecord::Base
  belongs_to :roster
  belongs_to :skater
end
