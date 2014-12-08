require "test_helper"
require "igrf/parsers/skaters"

describe Igrf::Parsers::Skaters do
  subject { Igrf::Parsers::Skaters }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @skater = @parser.parsed.first
  end

  it "parses an Igrf workbook for Skaters" do
    assert_equal "Singapore Rogue", @skater[:name]
    assert_equal "112", @skater[:number]
    assert_equal true, @skater[:away]
  end
end
