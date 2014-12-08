# == Schema Information
#
# Table name: team_states
#
#  id                        :integer          not null, primary key
#  name                      :string(255)
#  initials                  :string(255)
#  color_bar_style           :text
#  points                    :integer
#  is_taking_official_review :boolean
#  is_taking_timeout         :boolean
#  timeouts                  :integer
#  jammer_id                 :integer
#  created_at                :datetime
#  updated_at                :datetime
#  color                     :string(255)
#  official_reviews_retained :integer          default(0)
#  logo                      :text
#  jam_points                :integer
#  has_official_review       :boolean
#

require "test_helper"

describe TeamState do
  let(:team_state) { TeamState.new }

  it "must be valid" do
    team_state.must_be :valid?
  end
end
