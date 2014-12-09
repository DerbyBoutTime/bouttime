# == Schema Information
#
# Table name: pass_states
#
#  id            :integer          not null, primary key
#  pass_number   :integer
#  skater_number :string(255)
#  points        :integer
#  injury        :boolean
#  lead          :boolean
#  lost_lead     :boolean
#  calloff       :boolean
#  nopass        :boolean
#  created_at    :datetime
#  updated_at    :datetime
#  jam_state_id  :integer
#

require "test_helper"

describe PassState do
  let(:pass_state) { PassState.new }

  it "must be valid" do
    pass_state.must_be :valid?
  end
end
