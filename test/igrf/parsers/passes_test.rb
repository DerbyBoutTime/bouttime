require "test_helper"
require "igrf/parsers/passes"

describe Igrf::Parsers::Passes do
  subject { Igrf::Parsers::Passes }

  before do
    @parser = subject.new(Support::Igrf.workbook)
    @parser.parse

    @passes = @parser.parsed
    @pass = @passes.first
  end

  it "parses an Igrf workbok for Passes" do
    assert_kind_of Array, @passes
    assert_equal 124, @passes.size

    assert_kind_of Hash, @pass
    assert_equal 5, @pass[:score]
    assert_equal 2, @pass[:number]
    assert_equal 1, @pass[:jam_number]
    assert_equal 1, @pass[:period]
    assert_equal "911", @pass[:skater_number]
  end

  describe "during a Star Pass" do
    before do
      @pass = @passes.find { |pass| pass[:star_pass] }
    end

    it "tracks new Skater" do
      assert_equal "12", @pass[:skater_number]
    end
  end
end
