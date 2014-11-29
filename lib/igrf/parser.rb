require "rubyXL"

module IGRF
  class Parser
    attr_reader :game

    def self.parse(game)
      new(game).parse
    end

    def initialize(game)
      @game = game
    end

    def data
    end

    def parse
    end

    private

    def worksheets
      @game.workbook.worksheets
    end
  end
end

require_relative "parsers"
