require "test_helper"

describe RosterSkater do
  let(:roster_skater) { RosterSkater.new }

  it "must be valid" do
    roster_skater.must_be :valid?
  end
end
