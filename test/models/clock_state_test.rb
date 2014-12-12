# == Schema Information
#
# Table name: clock_states
#
#  id         :integer          not null, primary key
#  display    :string(16)
#  time       :integer
#  offset     :integer
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe ClockState do
  let(:clock_state) { ClockState.new }

  it "must be valid" do
    clock_state.must_be :valid?
  end
end
