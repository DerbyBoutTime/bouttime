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

require "test_helper"

describe PenaltyBoxState do
  let(:penalty_box_state) { PenaltyBoxState.new }

  it "must be valid" do
    penalty_box_state.must_be :valid?
  end
end
