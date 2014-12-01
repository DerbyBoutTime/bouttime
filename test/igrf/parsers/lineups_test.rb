require "test_helper"
require "igrf/parsers/lineups"

describe IGRF::Parsers::Lineups do
  subject { IGRF::Parsers::Lineups }

  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @lineup = @parser.parsed.first
  end

  it "parses an IGRF workbook for Lineups" do
    assert_equal 1, @lineup[:jam_number]
    assert_kind_of Array, @lineup[:skaters]
    assert_equal true, @lineup[:away]
  end
end
