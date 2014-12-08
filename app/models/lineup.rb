# == Schema Information
#
# Table name: lineups
#
#  id         :integer          not null, primary key
#  jam_id     :integer
#  roster_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Lineup < ActiveRecord::Base
  belongs_to :jam
  belongs_to :roster

  has_many :lineup_skaters
  has_many :skaters, :through => :lineup_skaters
end
