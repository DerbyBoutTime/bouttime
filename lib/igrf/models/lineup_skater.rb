require "igrf/model"

module IGRF
  module Models
    class LineupSkater
      def lineup
        parent
      end

      def skater
        @skater ||= lineup.jam.game.skaters.find { |skater| skater.number == number }
      end
    end
  end
end
