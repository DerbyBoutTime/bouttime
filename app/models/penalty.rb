# == Schema Information
#
# Table name: penalties
#
#  id               :integer          not null, primary key
#  lineup_skater_id :integer
#  code             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Penalty < ActiveRecord::Base
  belongs_to :lineup_skater
end
