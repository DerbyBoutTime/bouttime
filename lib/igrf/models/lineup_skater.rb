require "igrf/model"

module Igrf
  module Models
    class LineupSkater < Model
      def home?
        !!attributes[:home]
      end

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
