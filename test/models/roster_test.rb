require "test_helper"

describe Roster do
  let(:roster) { Roster.new }

  it "must be valid" do
    roster.must_be :valid?
  end
end
