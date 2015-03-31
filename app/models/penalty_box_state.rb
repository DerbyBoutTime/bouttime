# == Schema Information
#
# Table name: penalty_box_states
#
#  id             :integer          not null, primary key
#  skater_id      :integer
#  left_early     :boolean
#  served         :boolean
#  clock_state_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class PenaltyBoxState < ActiveRecord::Base
  belongs_to :skater
  belongs_to :clock_state
  private
  def init_clock_state
    self.build_clock_state(time: 0, display: "0")
  end
  after_initialize :init_clock_state
end
