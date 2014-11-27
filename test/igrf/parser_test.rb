require "test_helper"
require "igrf/parser"

describe IGRF::Parser do
  @@parser = IGRF::Parser.new(File.join("test", "igrf", "samples", "one.xlsx"))

  describe "#rosters" do
    before do
      @rosters = @@parser.rosters

      @away = @rosters.away
      @home = @rosters.home
    end

    it "returns Rosters" do
      assert_kind_of IGRF::Rosters, @rosters

      assert_kind_of IGRF::Roster, @away
      assert_kind_of IGRF::Roster, @home

      assert_equal "All-Stars", @away.name
      assert_equal "All-Stars", @home.name

      assert_equal "Houston Roller Derby", @away.league
      assert_equal "Rat City Rollergirls", @home.league

      assert_kind_of Array, @away.skaters
      assert_kind_of Array, @home.skaters

      assert_kind_of IGRF::Skater, @away.skaters.first
      assert_kind_of IGRF::Skater, @home.skaters.first

      assert_equal 14, @away.skaters.size
      assert_equal 16, @home.skaters.size

      assert_equal "112", @away.skaters.first.number
      assert_equal "Singapore Rogue", @away.skaters.first.name
      assert_equal "12", @home.skaters.first.number
      assert_equal "Carmen Getsome", @home.skaters.first.name
    end
  end

  describe "#venue" do
    before do
      @venue = @@parser.venue
    end

    it "returns a Venue" do
      assert_kind_of IGRF::Venue, @venue

      assert_equal "Key Arena", @venue.name
      assert_equal "Seattle", @venue.city
      assert_equal "WA", @venue.state
    end
  end
end
