require "test_helper"
require "igrf/parsers/rosters"

describe Igrf::Parsers::Rosters do
  subject { Igrf::Parsers::Rosters }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @roster = @parser.parsed.first
  end

  it "parses an Igrf workbook for Rosters" do
    assert_equal "Houston Roller Derby", @roster[:team_name]
    assert_kind_of Array, @roster[:skaters]
    assert_equal true, @roster[:away]
  end
end
