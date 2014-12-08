# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Team < ActiveRecord::Base
  has_many :rosters
  has_many :games, :through => :rosters

  has_many :skaters
end
