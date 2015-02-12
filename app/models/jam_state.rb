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
#

class JamState < ActiveRecord::Base
  belongs_to :team_state
  has_many :pass_states, -> { order('sort ASC') }

  before_create :set_jam_number

  accepts_nested_attributes_for :pass_states

  private

  def set_jam_number
    self.jam_number = self.team_state.jam_states.count + 1
  end

  def init_passes
  	self.pass_states.build(pass_number: 1, sort: 0) if self.pass_states.empty?
  end

  after_initialize :init_passes
end
