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

  accepts_nested_attributes_for :lineup_statuses

  accepts_nested_attributes_for :pass_states

  private

  def set_jam_number
    self.jam_number = self.team_state.jam_states.count + 1
  end

  def init_passes
    self.pass_states.build(pass_number: 1, sort: 0) if self.pass_states.empty?
  end

  before_create :set_jam_number
  after_initialize :init_passes
end
