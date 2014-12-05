require "test_helper"
require "igrf/parsers/venue"

describe Igrf::Parsers::Venue do
  subject { Igrf::Parsers::Venue }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @venue = @parser.parsed.first
  end

  it "parses an Igrf workbook for the Venue" do
    assert_equal "Seattle", @venue[:city]
    assert_equal "Key Arena", @venue[:name]
    assert_equal "WA", @venue[:state]
  end
end
