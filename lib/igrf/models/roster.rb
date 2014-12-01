require "igrf/model"

module IGRF
  module Models
    class Roster < Model
      def game
        parent
      end

      def skaters
        @skaters ||= attributes[:skaters].map { |skater| Skater.new(skater, self) }
      end
    end
  end
end
