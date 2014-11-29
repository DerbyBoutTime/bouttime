require "test_helper"

require "igrf"

describe IGRF do
  class_variable_set(:@@game, IGRF.for(File.join("test", "igrf", "samples", "one.xlsx")))

  before do
    @game = self.class.class_variable_get(:@@game)
  end

  describe "#for" do
    it "returns a Game" do
      assert_kind_of IGRF::Models::Game, @game
    end
  end

  describe "#jams" do
    before do
      @jams = @game.jams
      @jam = @jams.first
    end

    it "returns jams" do
      assert_kind_of Array, @jams
      assert_kind_of IGRF::Models::Jam, @jam

      assert_equal 1, @jam.number
      assert_equal 1, @jam.period
    end
  end

  #describe "#officials" do
    #before do
      #@officials = @parser.officials
      #@nso = @officials.find { |official| official.is_a?(IGRF::Models::NSO) }
      #@referee = @officials.find { |official| official.is_a?(IGRF::Models::Referee) }
    #end

    #it "returns officials" do
      #assert_kind_of Array, @officials

      #assert_equal "Wizard of Laws", @nso.name
      #assert_equal "HNSO", @nso.position
      #assert_equal "Rat City", @nso.league
      #assert_equal 2, @nso.cert

      #assert_equal "Mike Hammer", @referee.name
      #assert_equal "HR/IPR", @referee.position
      #assert_equal "Rat City", @referee.league
      #assert_equal 3, @referee.cert
    #end
  #end

  #describe "#rosters" do
    #before do
      #@rosters = @parser.rosters

      #@away = @rosters.away
      #@home = @rosters.home
    #end

    #it "returns Rosters" do
      #assert_kind_of IGRF::Models::Rosters, @rosters

      #assert_kind_of IGRF::Models::Roster, @away
      #assert_kind_of IGRF::Models::Roster, @home

      #assert_equal "All-Stars", @away.name
      #assert_equal "All-Stars", @home.name

      #assert_equal "Houston Roller Derby", @away.league
      #assert_equal "Rat City Rollergirls", @home.league

      #assert_kind_of Array, @away.skaters
      #assert_kind_of Array, @home.skaters

      #assert_kind_of IGRF::Models::Skater, @away.skaters.first
      #assert_kind_of IGRF::Models::Skater, @home.skaters.first

      #assert_equal 14, @away.skaters.size
      #assert_equal 16, @home.skaters.size

      #assert_equal "112", @away.skaters.first.number
      #assert_equal "Singapore Rogue", @away.skaters.first.name
      #assert_equal "12", @home.skaters.first.number
      #assert_equal "Carmen Getsome", @home.skaters.first.name
    #end
  #end

  #describe "#venue" do
    #before do
      #@venue = @parser.venue
    #end

    #it "returns a Venue" do
      #assert_kind_of IGRF::Models::Venue, @venue

      #assert_equal "Key Arena", @venue.name
      #assert_equal "Seattle", @venue.city
      #assert_equal "WA", @venue.state
    #end
  #end
end
