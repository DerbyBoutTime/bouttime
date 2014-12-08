# == Schema Information
#
# Table name: lineup_skaters
#
#  id         :integer          not null, primary key
#  lineup_id  :integer
#  skater_id  :integer
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LineupSkater < ActiveRecord::Base
  belongs_to :lineup
  belongs_to :skater

  has_one :penalty

  has_many :passes
end
