module IGRF
  class Game
    attr_reader :workbook

    def initialize(file)
      @workbook = RubyXL::Parser.parse(file)
    end

    def jams
      @jams ||= Jam.for(game)
    end
  end
end
