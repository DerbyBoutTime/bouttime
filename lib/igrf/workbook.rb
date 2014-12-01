require "rubyXL"

require "igrf/parsers/game"

module IGRF
  class Workbook
    attr_reader :workbook

    def initialize(file)
      @workbook = RubyXL::Parser.parse(file)
    end

    def to_game
      @to_game ||= Models::Game.new(IGRF::Parsers::Game.parse(self).parsed.first)
    end

    def worksheets
      workbook.worksheets
    end
  end
end
