require "igrf/model"

module Igrf
  module Models
    class Roster < Model
      def game
        parent
      end

      def home?
        !!attributes[:home]
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
