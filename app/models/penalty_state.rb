# == Schema Information
#
# Table name: penalty_states
#
#  id              :integer          not null, primary key
#  skater_state_id :integer
#  penalty_id      :integer
#  sort            :integer
#  jam_number      :integer
#  created_at      :datetime
#  updated_at      :datetime
#
class PenaltyState < ActiveRecord::Base
  belongs_to :penalty
  belongs_to :skater_state
end
