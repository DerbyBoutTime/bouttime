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

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :team_name].include?(key) }}>"
      end
    end
  end
end
