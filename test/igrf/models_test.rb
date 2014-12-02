require "test_helper"

require "igrf/models"

describe IGRF::Models do
  before do
    @game = Support::IGRF.game
  end

  describe IGRF::Models::Game do
    it "has children" do
      assert_kind_of Array, @game.jams
      assert_kind_of IGRF::Models::Jam, @game.jams.first

      assert_kind_of Array, @game.officials
      assert_kind_of IGRF::Models::Official, @game.officials.first

      assert_kind_of Array, @game.penalties
      assert_kind_of IGRF::Models::Penalty, @game.penalties.first

      assert_kind_of Array, @game.rosters
      assert_kind_of IGRF::Models::Roster, @game.rosters.first

      assert_kind_of IGRF::Models::Venue, @game.venue
    end
  end

  describe IGRF::Models::Jam do
    before do
      @jam = @game.jams[1]
    end

    it "has children" do
      assert_kind_of IGRF::Models::Lineup, @jam.lineup

      assert_kind_of Array, @jam.passes
      assert_kind_of IGRF::Models::Pass, @jam.passes.first
    end

    it "has a parent" do
      assert_equal @game, @jam.parent
    end
  end

  describe IGRF::Models::Lineup do
    before do
      @jam = @game.jams.first
      @lineup = @jam.lineup
    end

    it "has a parent" do
      assert_equal @jam, @lineup.parent
    end
  end

  describe IGRF::Models::Official do
    before do
      @official = @game.officials.first
    end

    it "has a parent" do
      assert_equal @game, @official.parent
    end
  end

  describe IGRF::Models::Penalty do
    before do
      @penalty = @game.penalties.first
    end

    it "has a parent" do
      assert_equal @game, @penalty.parent
    end
  end

  describe IGRF::Models::Roster do
    before do
      @roster = @game.rosters.first
    end

    it "has children" do
      assert_kind_of Array, @roster.skaters
      assert_kind_of IGRF::Models::Skater, @roster.skaters.first
    end

    it "has a parent" do
      assert_equal @game, @roster.parent
    end
  end

  describe IGRF::Models::Skater do
    before do
      @roster = @game.rosters.first
      @skater = @roster.skaters.first
    end

    it "has a parent" do
      assert_equal @roster, @skater.parent
    end
  end

  describe IGRF::Models::Venue do
    before do
      @venue = @game.venue
    end
  end
end
