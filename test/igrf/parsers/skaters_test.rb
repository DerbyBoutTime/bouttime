require "test_helper"
require "igrf/parsers/skaters"

describe IGRF::Parsers::Skaters do
  subject { IGRF::Parsers::Skaters }

  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @skater = @parser.parsed.first
  end

  it "parses an IGRF workbook for Skaters" do
    assert_equal "Singapore Rogue", @skater[:name]
    assert_equal "112", @skater[:number]
    assert_equal true, @skater[:away]
  end
end
