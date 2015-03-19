# == Schema Information
#
# Table name: pass_states
#
#  id            :integer          not null, primary key
#  pass_number   :integer
#  skater_number :string(255)
#  points        :integer
#  injury        :boolean
#  lead          :boolean
#  lost_lead     :boolean
#  calloff       :boolean
#  nopass        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  jam_state_id  :integer
#  is_selected   :boolean          default(FALSE)
#  sort          :integer
#

class PassState < ActiveRecord::Base
  belongs_to :jam_state

  after_save if: :points_changed? do |pass_state|
    pass_state.jam_state.team_state.update_points
  end
end
