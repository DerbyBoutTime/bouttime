# == Schema Information
#
# Table name: skaters
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  name       :string(255)
#  number     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Skater < ActiveRecord::Base
  belongs_to :team

  has_many :lineup_skaters
  has_many :lineups, :through => :lineup_skaters
  has_many :penalties, :through => :lineup_skaters

  has_many :roster_skaters
  has_many :rosters, :through => :roster_skaters
end
