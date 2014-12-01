require "test_helper"
require "igrf/parsers/penalties"

describe IGRF::Parsers::Penalties do
  subject { IGRF::Parsers::Penalties }

  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @penalty = @parser.parsed.first
  end

  it "parses an IGRF workbook for the Penalties" do
    assert_equal true, @penalty[:away]
    assert_equal 1, @penalty[:period]
    assert_equal 12, @penalty[:skater_number]

    assert_kind_of Array, @penalty[:penalties]
    assert_equal 9, @penalty[:penalties].first[:jam_number]
    assert_equal "P", @penalty[:penalties].first[:code]
  end
end
