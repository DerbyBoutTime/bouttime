require "igrf/model"

module IGRF
  module Models
    class Lineup < Model
      def jam
        parent
      end

      def blockers
        @blockers ||= skaters.select { |skater| skater.role == "blocker" }
      end

      def jammer
        @jammer ||= skaters.find { |skater| skater.role == "jammer" }
      end

      def pivot
        @pivot ||= skaters.find { |skater| skater.role == "pivot" }
      end

      def pivot?
        pivot
      end

      def skaters
        @skaters ||= attributes[:skaters].map { |skater| LineupSkater.new(skater, self) }
      end

      def star_pass?
        jam.star_pass?
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :jam_number, :period].include?(key) }}>"
      end
    end
  end
end
