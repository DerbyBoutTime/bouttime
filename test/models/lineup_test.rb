require "test_helper"

describe Lineup do
  let(:lineup) { Lineup.new }

  it "must be valid" do
    lineup.must_be :valid?
  end
end
