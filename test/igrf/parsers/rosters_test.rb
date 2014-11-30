require "test_helper"
require "igrf/parsers/rosters"

describe IGRF::Parsers::Rosters do
  subject { IGRF::Parsers::Rosters }

  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @roster = @parser.parsed.first
  end

  it "parses an IGRF workbook for the Rosters" do
    assert_equal "Houston Roller Derby", @roster[:team_name]
    assert_kind_of Array, @roster[:skaters]
    assert_equal true, @roster[:away]
  end
end
