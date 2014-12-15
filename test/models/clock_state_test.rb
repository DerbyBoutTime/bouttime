# == Schema Information
#
# Table name: clock_states
#
#  id         :integer          not null, primary key
#  display    :string(16)
#  created_at :datetime
#  updated_at :datetime
#  time       :integer
#

require "test_helper"

describe ClockState do
  let(:clock_state) { ClockState.new }

  it "must be valid" do
    clock_state.must_be :valid?
  end
end
