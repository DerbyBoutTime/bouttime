require "test_helper"
require "igrf/parsers/lineups"

describe Igrf::Parsers::Lineups do
  subject { Igrf::Parsers::Lineups }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @lineup = @parser.parsed.first
  end

  it "parses an Igrf workbook for Lineups" do
    assert_equal 1, @lineup[:jam_number]
    assert_kind_of Array, @lineup[:skaters]
    assert_equal true, @lineup[:away]
  end
end
