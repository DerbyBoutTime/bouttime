# == Schema Information
#
# Table name: jam_states
#
#  id            :integer          not null, primary key
#  team_state_id :integer
#  jam_number    :integer
#  skater_number :string(255)
#  points        :integer
#  injury        :boolean
#  lead          :boolean
#  lost_lead     :boolean
#  calloff       :boolean
#  nopass        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  is_selected   :boolean          default(FALSE)
#  no_pivot      :boolean
#  star_pass     :boolean
#  pivot_id      :integer
#  blocker1_id   :integer
#  blocker2_id   :integer
#  blocker3_id   :integer
#  jammer_id     :integer
#

class JamState < ActiveRecord::Base
  belongs_to :team_state
  belongs_to :pivot, class_name: 'Skater'
  belongs_to :blocker1, class_name: 'Skater'
  belongs_to :blocker2, class_name: 'Skater'
  belongs_to :blocker3, class_name: 'Skater'
  belongs_to :jammer, class_name: 'Skater'
  has_many :pass_states
  has_many :lineup_statuses
end
