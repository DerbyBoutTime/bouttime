require "test_helper"
require "igrf/parsers/game"

describe Igrf::Parsers::Game do
  subject { Igrf::Parsers::Game }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @game = @parser.parsed.first
  end

  it "parses an Igrf workbook for the Game" do
    assert_equal Time.new(2014, 7, 12, 20), @game[:start_time]
    assert_equal Time.new(2014, 7, 12, 21, 30), @game[:end_time]

    assert_kind_of Array, @game[:jams]
    assert_kind_of Array, @game[:penalties]
    assert_kind_of Array, @game[:rosters]
    assert_kind_of Hash, @game[:venue]
  end
end
