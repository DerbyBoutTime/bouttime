require "rubyXL"

require_relative "parsers"
require_relative "structs"

module IGRF
  class Parser
    attr_reader :venue, :workbook

    def initialize(file)
      @workbook = RubyXL::Parser.parse(file)
      @worksheet_data = {}
    end

    def referees
      @referees ||= Parsers::RefereesParser.new(data_for_worksheet(2)).parse
    end

    def rosters
      @rosters ||= Parsers::RostersParser.new(data_for_worksheet(2)).parse
    end

    def venue
      @venue ||= Parsers::VenueParser.new(data_for_worksheet(2)).parse
    end

    private

    def data_for_worksheet(number)
      @worksheet_data[number] ||= @workbook.worksheets[number].extract_data
    end
  end
end
