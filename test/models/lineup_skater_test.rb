require "test_helper"

describe LineupSkater do
  let(:lineup_skater) { LineupSkater.new }

  it "must be valid" do
    lineup_skater.must_be :valid?
  end
end
