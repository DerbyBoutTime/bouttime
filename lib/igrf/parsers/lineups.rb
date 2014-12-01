require "igrf/parser"
require "igrf/parsers/lineups"

module IGRF
  module Parsers
    class Lineups < TeamParser
      def columns
        { :away => { :jam_number => 0, :no_pivot => 1,
            :jammer => 2, :jammer_box_one => 3, :jammer_box_two => 4, :jammer_box_three => 5,
            :pivot => 6, :pivot_box_one => 7, :pivot_box_two => 8, :pivot_box_three => 9,
            :blocker_one => 10, :blocker_one_box_one => 11, :blocker_one_box_two => 12, :blocker_one_box_three => 13,
            :blocker_two => 14, :blocker_two_box_one => 15, :blocker_two_box_two => 16, :blocker_two_box_three => 17,
            :blocker_three => 18, :blocker_three_box_one => 19, :blocker_three_box_two => 20, :blocker_three_box_three => 21
          },
          :home => { :jam_number => 26, :no_pivot => 27,
            :jammer => 28, :jammer_box_one => 29, :jammer_box_two => 30, :jammer_box_three => 31,
            :pivot => 32, :pivot_box_one => 33, :pivot_box_two => 34, :pivot_box_three => 35,
            :blocker_one => 38, :blocker_one_box_one => 39, :blocker_one_box_two => 40, :blocker_one_box_three => 41,
            :blocker_two => 42, :blocker_two_box_one => 43, :blocker_two_box_two => 44, :blocker_two_box_three => 45,
            :blocker_three => 46, :blocker_three_box_one => 47, :blocker_three_box_two => 48, :blocker_three_box_three => 49
          } }
      end

      def data
        @data ||= worksheets[5].extract_data
      end

      def rows
        3.upto(34).map { |number| [number, { :period => 1 }] } +
          49.upto(80).map { |number| [number, { :period => 2 }] }
      end

      private

      def _parse(row, columns, hash)
        super

        hash[:skaters] = skaters(hash)
        hash.select { |key, _| [:away, :home, :period, :jam_number, :no_pivot, :skaters].include?(key) }
      end

      def skater(role, hash)
        { :role => role.to_s.gsub(/_.*/, ""), :number => hash[role], :boxes => [hash["#{role}_box_one".to_sym], hash["#{role}_box_two".to_sym], hash["#{role}_box_three".to_sym]] }
      end

      def skaters(hash)
        skaters = []

        [:jammer, :pivot, :blocker_one, :blocker_two, :blocker_three].each do |role|
          skaters << skater(role, hash) if hash[role].present?
        end

        skaters
      end
    end
  end
end
