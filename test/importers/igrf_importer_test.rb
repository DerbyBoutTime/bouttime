require "test_helper"

require "igrf_importer"

describe Importers::IGRFImporter, :model do
  before do
    @parsed = Support::IGRF.game

    @parsed_official = @parsed.officials.first

    @parsed_roster = @parsed.rosters.find { |roster| roster.home? }
    @parsed_skater = @parsed_roster.skaters.find { |skater| skater.number.to_s == "911" }

    @parsed_jam = @parsed.jams.find { |jam| jam.home? }
    @parsed_lineup = @parsed_jam.lineup
    @parsed_lineup_skater = @parsed_lineup.skaters.find { |skater| skater.number.to_s == "911" }
    @parsed_pass = @parsed_jam.passes.find { |pass| pass.skater_number.to_s == "911" }

    @parsed_penalty = @parsed.penalties.find { |penalty| penalty.home? && penalty.skater_number.to_s == "911" }
    @parsed_penalty.attributes[:penalties] = [@parsed_penalty.attributes[:penalties].first]

    IGRF::Models::Game.stub_any_instance :officials, [@parsed_official] do
      IGRF::Models::Game.stub_any_instance :rosters, [@parsed_roster] do
        IGRF::Models::Roster.stub_any_instance :skaters, [@parsed_skater] do
          IGRF::Models::Game.stub_any_instance :jams, [@parsed_jam] do
            IGRF::Models::Jam.stub_any_instance :passes, [@parsed_pass] do
              IGRF::Models::Lineup.stub_any_instance :skaters, [@parsed_lineup_skater] do
                IGRF::Models::Game.stub_any_instance :penalties, [@parsed_penalty] do
                  @game = Importers::IGRFImporter::Game.new(@parsed).import
                end
              end
            end
          end
        end
      end
    end
  end

  it "imports" do
    assert_equal 1, Venue.count

    venue = @game.venue
    assert_equal @parsed.venue.city, venue.city
    assert_equal @parsed.venue.name, venue.name
    assert_equal @parsed.venue.state, venue.state

    assert_equal 1, Game.count

    assert_equal @parsed.end_time, @game.end_time
    assert_equal @parsed.start_time, @game.start_time

    assert_equal 1, Official.count
    assert_equal 1, GameOfficial.count

    game_official = @game.game_officials.first
    official = game_official.official

    assert_equal @parsed_official.position, game_official.position
    assert_equal @parsed_official.certification.to_s, official.certification
    assert_equal @parsed_official.league, official.league
    assert_equal @parsed_official.name, official.name

    assert_equal 1, Team.count
    assert_equal 1, Roster.count
    assert_equal 1, Skater.count

    roster = @game.rosters.first
    team = roster.team
    skater = roster.skaters.first

    assert_equal @parsed_roster.home?, roster.home?
    assert_equal @parsed_roster.team_name, team.name
    assert_equal @parsed_skater.name, skater.name
    assert_equal @parsed_skater.number, skater.number

    assert_equal 1, Jam.count
    assert_equal 1, Lineup.count
    assert_equal 1, Pass.count

    jam = @game.jams.first
    lineup = jam.lineups.first
    lineup_skater = lineup.lineup_skaters.first
    pass = jam.passes.first

    assert_equal @parsed_jam.number, jam.number
    assert_equal @parsed_jam.period, jam.period
    assert_equal @parsed_lineup_skater.role, lineup_skater.role
    assert_equal pass.lineup_skater, lineup_skater
    assert_equal @parsed_pass.number, pass.number
    assert_equal @parsed_pass.score, pass.score

    assert_equal 1, Penalty.count

    penalty = jam.penalties.first

    assert_equal @parsed_penalty.penalties.first[:code], penalty.code
    assert_equal penalty.lineup_skater, lineup_skater
  end
end
