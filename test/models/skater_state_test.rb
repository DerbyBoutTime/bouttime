# == Schema Information
#
# Table name: skater_states
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  number        :string(255)
#  team_state_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require "test_helper"

describe SkaterState do
  let(:skater_state) { SkaterState.new }

  it "must be valid" do
    skater_state.must_be :valid?
  end
end
