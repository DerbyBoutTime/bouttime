require "test_helper"
require "igrf/parsers/penalties"

describe Igrf::Parsers::Penalties do
  subject { Igrf::Parsers::Penalties }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @penalty = @parser.parsed[2]
  end

  it "parses an Igrf workbook for Penalties" do
    assert_equal true, @penalty[:home]
    assert_equal 1, @penalty[:period]
    assert_equal 12, @penalty[:skater_number]

    assert_kind_of Array, @penalty[:penalties]
    assert_equal 9, @penalty[:penalties].first[:jam_number]
    assert_equal "P", @penalty[:penalties].first[:code]
  end
end
