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
require "test_helper"
describe PenaltyState do
  let(:penalty_state) { PenaltyState.new }
  it "must be valid" do
    penalty_state.must_be :valid?
  end
end
