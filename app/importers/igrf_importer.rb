require "igrf"

module Importers
  module IGRFImporter
    def self.import(file)
      ActiveRecord::Base.transaction { Game.new(IGRF.for(file)).import }
    end

    class Game
      attr_reader :game

      def initialize(game)
        @game = game
      end

      def import
        venue = Venue.new(game.venue).import
        _game = ::Game.create!(end_time: game.end_time, start_time: game.start_time, venue: venue)

        game.officials.each do |official|
          Official.new(official, _game).import
        end

        game.rosters.each do |roster|
          Roster.new(roster, _game).import
        end

        game.jams.each do |jam|
          Jam.new(jam, _game).import
        end

        game.penalties.each do |penalty|
          Penalty.new(penalty, _game).import
        end

        _game
      end
    end

    class Jam
      attr_reader :jam, :_game

      def initialize(jam, _game)
        @jam = jam
        @_game = _game
      end

      def import
        _jam = ::Jam.find_or_create_by!(game: _game, number: jam.number, period: jam.period)

        _lineup = Lineup.new(jam.lineup, _jam).import

        jam.passes.each do |pass|
          Pass.new(pass, _lineup).import
        end

        _jam
      end
    end

    class Lineup
      attr_reader :lineup, :_jam, :_roster

      def initialize(lineup, _jam)
        @lineup = lineup
        @_jam = _jam
        @_roster = _jam.game.rosters.where(home: lineup.home?).first
      end

      def import
        _lineup = ::Lineup.create!(jam: _jam, roster: _roster)

        lineup.skaters.each do |skater|
          _skater = ::Skater.where(number: skater.number.to_s, team: _roster.team).first

          ::LineupSkater.create!(lineup: _lineup, skater: _skater, role: skater.role)
        end

        _lineup
      end
    end

    class Official
      attr_reader :official, :_game

      def initialize(official, _game)
        @official = official
        @_game = _game
      end

      def import
        _official = ::Official.find_or_create_by!(certification: official.certification.to_s, league: official.league, name: official.name)

        ::GameOfficial.create!(game: _game, official: _official, position: official.position)

        _official
      end
    end

    class Pass
      attr_reader :pass, :_lineup, :_lineup_skater

      def initialize(pass, _lineup)
        @pass = pass
        @_lineup = _lineup
        @_lineup_skater = _lineup.lineup_skaters.joins(:skater).where(skaters: { number: pass.skater_number.to_s }).first
      end

      def import
        ::Pass.create!(lineup_skater: _lineup_skater, number: pass.number, score: pass.score)
      end
    end

    class Penalty
      attr_reader :penalty, :_game

      def initialize(penalty, _game)
        @penalty = penalty
        @_game = _game
      end

      def import
        penalty.penalties.each do |penalty|
          _lineup_skater = LineupSkater.joins(lineup: [{ jam: :game }, :roster]).joins(:skater).
            where(games: { id: _game.id }, jams: { number: penalty[:jam_number], period: @penalty.period }, rosters: { home: @penalty.home? }, skaters: { number: @penalty.skater_number.to_s }).first
          ::Penalty.create!(lineup_skater: _lineup_skater, code: penalty[:code])
        end
      end
    end

    class Roster
      attr_reader :roster, :_game

      def initialize(roster, _game)
        @roster = roster
        @_game = _game
      end

      def import
        _team = ::Team.find_or_create_by!(name: roster.team_name)
        _roster = ::Roster.create!(home: roster.home?, game: _game, team: _team)

        _roster.skaters << roster.skaters.map do |skater|
          ::Skater.find_or_create_by!(name: skater.name, number: skater.number.to_s, team: _team)
        end

        _roster
      end
    end

    class Venue
      attr_reader :venue

      def initialize(venue)
        @venue = venue
      end

      def import
        ::Venue.find_or_create_by!(city: venue.city, name: venue.name, state: venue.state)
      end
    end
  end
end
