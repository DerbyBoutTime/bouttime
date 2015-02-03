# == Schema Information
#
# Table name: lineup_team_states
#
#  id              :integer          not null, primary key
#  no_pivot        :boolean
#  star_pass       :boolean
#  pivot_number    :string(255)
#  blocker1_number :string(255)
#  blocker2_number :string(255)
#  blocker3_number :string(255)
#  jammer_number   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require "test_helper"

describe LineupTeamState do
  let(:lineup_team_state) { LineupTeamState.new }

  it "must be valid" do
    lineup_team_state.must_be :valid?
  end
end
