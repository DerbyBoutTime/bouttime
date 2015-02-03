# == Schema Information
#
# Table name: lineup_status_states
#
#  id                   :integer          not null, primary key
#  pivot                :string(255)
#  blocker1             :string(255)
#  blocker2             :string(255)
#  blocker3             :string(255)
#  jammer               :string(255)
#  lineup_team_state_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class LineupStatusState < ActiveRecord::Base
  belongs_to :lineup_team_state
end
