require "rubyXL"

require "igrf/parsers/game"

module Igrf
  class Workbook
    attr_reader :file

    def initialize(file)
      @data = {}
      @file = file
    end

    def extract_data(worksheet)
      @data[worksheet] ||= worksheets[worksheet].extract_data
    end

    def to_game
      @to_game ||= Models::Game.new(Igrf::Parsers::Game.parse(self).parsed.first)
    end

    def workbook
      @workbook ||= RubyXL::Parser.parse(file)
    end

    def worksheets
      @worksheets ||= workbook.worksheets
    end
  end
end
