require "rubyXL"

require_relative "parsers"
require_relative "structs"

module IGRF
  class Parser
    attr_reader :venue, :game

    def initialize(game)
      @game = game
    end

    def parse
      IGRF::Models::Game.new(jams, officials, rosters, venue)
    end

    def jams
      @jams ||= Parsers::JamsParser.new(game).parse
    end

    def officials
      @officials ||= Parsers::OfficialsParser.new(game).parse
    end

    def rosters
      @rosters ||= Parsers::RostersParser.new(game).parse
    end

    def venue
      @venue ||= Parsers::VenueParser.new(game).parse
    end
  end
end
