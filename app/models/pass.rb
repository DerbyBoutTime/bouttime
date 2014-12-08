# == Schema Information
#
# Table name: passes
#
#  id               :integer          not null, primary key
#  lineup_skater_id :integer
#  number           :integer
#  score            :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Pass < ActiveRecord::Base
  belongs_to :lineup_skater
end
