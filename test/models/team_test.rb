# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "test_helper"

describe Team do
  let(:team) { Team.new }

  it "must be valid" do
    team.must_be :valid?
  end
end
