# == Schema Information
#
# Table name: jammer_states
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  number     :string(255)
#  is_lead    :boolean
#  created_at :datetime
#  updated_at :datetime
#
require "test_helper"
describe JammerState do
  let(:jammer_state) { JammerState.new }
  it "must be valid" do
    jammer_state.must_be :valid?
  end
end
