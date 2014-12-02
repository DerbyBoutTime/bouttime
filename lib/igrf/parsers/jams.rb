require "igrf/parser"
require "igrf/parsers/lineups"
require "igrf/parsers/passes"

module IGRF
  module Parsers
    class Jams < TeamParser
      def columns
        { :away => { :number => 19 },
          :home => { :number => 0 } }
      end

      def data
        @data ||= worksheets[3].extract_data
      end

      def parse
        rows.each do |number, hash|
          columns.each do |split, columns|
            _parsed = _parse(data[number], columns, { split => true }.merge(hash || {}))

            parsed << _parsed if _parsed[:number].is_a?(Integer)
          end
        end

        true
      end

      def rows
        3.upto(36).map { |number| [number, { :period => 1 }] } +
          50.upto(83).map { |number| [number, { :period => 2 }] }
      end

      private

      def _parse(row, columns, hash)
        super

        hash[:lineup] = Parsers::Lineups.parse(workbook).parsed.send(hash.keys.first).find { |lineup| [hash[:period], hash[:number]] == [lineup[:period], lineup[:jam_number]] }
        hash[:passes] = Parsers::Passes.parse(workbook).parsed.select { |pass| [hash[:period], hash[:number], hash[hash.keys.first]] == [pass[:period], pass[:jam_number], pass[hash.keys.first]] }
        hash
      end
    end
  end
end
