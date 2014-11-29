module IGRF
  module Models
    class Jam < Base
      attr_accessor :game

      def self.for(game)
        Parsers::Jams.parse(game).map do |hash|
          jam = new(hash)
          jam.game = game
          jam
        end
      end
    end
  end
end
