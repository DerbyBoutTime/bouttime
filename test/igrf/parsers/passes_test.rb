require "test_helper"
require "igrf/parsers/passes"


describe IGRF::Parsers::Passes do
  subject { IGRF::Parsers::Passes }
  before do
    @parser = subject.new(Support::IGRF.workbook)
    @parser.parse

    @passes = @parser.parsed
    @pass = @passes.first
  end

  it "returns passes" do
    assert_kind_of Array, @passes
    assert_equal 124, @passes.size

    assert_kind_of Hash, @pass
    assert_equal 5, @pass[:score]
    assert_equal 2, @pass[:number]
    assert_equal 1, @pass[:jam_number]
    assert_equal 1, @pass[:period]
    assert_equal "911", @pass[:skater_number]
  end

  # [ { score: 1, jam_number: 1, period: 1, away: true, star_pass: true, skater_number: 12 } ]
  it "should track star passes and skater_number" do
    assert_equal 3, @passes.select{|pass| pass[:star_pass] && pass[:jam_number] == 24 && pass[:skater_number] == "12" }.count
  end
end
