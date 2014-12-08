require "test_helper"

describe Venue do
  let(:venue) { Venue.new }

  it "must be valid" do
    venue.must_be :valid?
  end
end
