require "igrf/parser"
require "igrf/parsers/lineups"

module Igrf
  module Parsers
    class Lineups < TeamParser
      def columns
        { :away => { :jam_number => 26, :no_pivot => 27,
            :jammer => 28, :jammer_boxes => 29..31,
            :pivot => 32, :pivot_boxes => 33..35,
            :blocker_one => 36, :blocker_one_boxes => 37..39,
            :blocker_two => 40, :blocker_two_boxes => 41..43,
            :blocker_three => 44, :blocker_three_boxes => 45..47
          },
          :home => { :jam_number => 0, :no_pivot => 1,
            :jammer => 2, :jammer_boxes => 3..5,
            :pivot => 6, :pivot_boxes => 7..9,
            :blocker_one => 10, :blocker_one_boxes => 11..13,
            :blocker_two => 14, :blocker_two_boxes => 15..17,
            :blocker_three => 18, :blocker_three_boxes => 19..21
          } }
      end

      def data
        workbook.extract_data(5)
      end

      def parse
        rows.each do |number, hash|
          columns.each do |split, columns|
            _parsed = _parse(data[number], columns, { split => true }.merge(hash || {}))

            parsed << _parsed if _parsed[:jam_number].is_a?(Integer)
          end
        end

        true
      end

      def rows
        3.upto(34).map { |number| [number, { :period => 1 }] } +
          49.upto(80).map { |number| [number, { :period => 2 }] }
      end

      private

      def _parse(row, columns, hash)
        super

        hash[:skaters] = skaters(hash)
        hash.select { |key, _| [:away, :home, :period, :jam_number, :skaters].include?(key) }
      end

      def skater(role, hash)
        { :role => ((role == :pivot && hash[:no_pivot].present?) ? "blocker" : role.to_s.gsub(/_.*/, "")),
          :number => hash[role],
          :boxes => hash["#{role}_boxes".to_sym] }
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
