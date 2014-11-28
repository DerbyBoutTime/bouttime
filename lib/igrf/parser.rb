require "rubyXL"

require_relative "parsers"
require_relative "structs"

module IGRF
  class Parser
    attr_reader :venue, :workbook

    def initialize(file)
      @workbook = RubyXL::Parser.parse(file)
    end

    def parse
      IGRF::Game.new(jams, officials, rosters, venue)
    end

    def jams
      @jams ||= Parsers::JamsParser.new(workbook).parse
    end

    def officials
      @officials ||= Parsers::OfficialsParser.new(workbook).parse
    end

    def rosters
      @rosters ||= Parsers::RostersParser.new(workbook).parse
    end

    def venue
      @venue ||= Parsers::VenueParser.new(workbook).parse
    end
  end
end
