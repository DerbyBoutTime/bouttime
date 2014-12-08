# == Schema Information
#
# Table name: roster_skaters
#
#  id         :integer          not null, primary key
#  roster_id  :integer
#  skater_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class RosterSkater < ActiveRecord::Base
  belongs_to :roster
  belongs_to :skater
end
