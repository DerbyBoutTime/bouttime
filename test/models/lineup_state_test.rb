# == Schema Information
#
# Table name: lineup_states
#
#  id            :integer          not null, primary key
#  jam_number    :integer
#  jam_ended     :boolean
#  game_state_id :integer
#  home_state_id :integer
#  away_state_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require "test_helper"

describe LineupState do
  let(:lineup_state) { LineupState.new }

  it "must be valid" do
    lineup_state.must_be :valid?
  end
end
