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

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :boxes, :number, :role].include?(key) }}>"
      end
    end
  end
end
