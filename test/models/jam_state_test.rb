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

require "test_helper"

describe JamState do
  let(:jam_state) { JamState.new }

  it "must be valid" do
    jam_state.must_be :valid?
  end
end
