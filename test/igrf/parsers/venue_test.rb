require "test_helper"
require "igrf/parsers/venue"

describe IGRF::Parsers::Venue do
  subject { IGRF::Parsers::Venue }

  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @venue = @parser.parsed.first
  end

  it "parses an IGRF workbook for the Venue" do
    assert_equal "Seattle", @venue[:city]
    assert_equal "Key Arena", @venue[:name]
    assert_equal "WA", @venue[:state]
  end
end
