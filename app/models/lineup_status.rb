# == Schema Information
#
# Table name: lineup_statuses
#
#  id           :integer          not null, primary key
#  pivot        :string(255)
#  blocker1     :string(255)
#  blocker2     :string(255)
#  blocker3     :string(255)
#  jammer       :string(255)
#  jam_state_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  order        :integer
#

class LineupStatus < ActiveRecord::Base
  belongs_to :jam_state
end
