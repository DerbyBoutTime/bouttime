require "test_helper"

describe Team do
  let(:team) { Team.new }

  it "must be valid" do
    team.must_be :valid?
  end
end
