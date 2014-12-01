require "igrf/parser"
require "igrf/parsers/lineups"
require "igrf/parsers/passes"

module IGRF
  module Parsers
    class Jams < TeamParser
      def columns
        { :home => { :number => 0 },
          :away => { :number => 19 } }
      end

      def data
        @data ||= worksheets[3].extract_data
      end

      def parse
        rows.each do |number, hash|
          columns.each do |split, columns|
            _parsed = _parse(data[number], columns, { split => true }.merge(hash || {}))

            if _parsed[:number].is_a?(Integer)
              parsed << _parsed
            elsif _parsed[:number].is_a?(String)
              handle_star_pass(_parsed)
            end
          end
        end

        true
      end

      def rows
        3.upto(36).map { |number| [number, { :period => 1 }] } +
          50.upto(83).map { |number| [number, { :period => 2 }] }
      end

      private

      def handle_star_pass(jam)
        previous_jam = parsed.last
        last_pass = previous_jam[:passes].take_while { |pass| pass[:number] }.last[:number]
        previous_jam[:star_pass] = last_pass
        previous_jam[:passes] = Parsers::Passes.parse(workbook).parsed.select { |pass| [previous_jam[:period], previous_jam[:number], previous_jam[previous_jam.keys.first]] == [pass[:period], pass[:jam_number], pass[previous_jam.keys.first]] }
      end

      def _parse(row, columns, hash)
        super
        hash[:passes] = Parsers::Passes.parse(workbook).parsed.select { |pass| [hash[:period], hash[:number], hash[hash.keys.first]] == [pass[:period], pass[:jam_number], pass[hash.keys.first]] }
        hash[:lineup] = Parsers::Lineups.parse(workbook).parsed.send(hash.keys.first).find { |lineup| [hash[:period], hash[:number]] == [lineup[:period], lineup[:jam_number]] }
        hash
      end
    end
  end
end
