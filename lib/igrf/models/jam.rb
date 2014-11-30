require "igrf/model"

module IGRF
  module Models
    class Jam < Model
      attr_accessor :game

      def self.for(game)
        Parsers::Jams.parse(game.workbook).map do |hash|
          jam = new(hash)
          jam.game = game
          jam
        end
      end

      def passes
        @passes ||= Pass.for(self)
      end
    end
  end
end
