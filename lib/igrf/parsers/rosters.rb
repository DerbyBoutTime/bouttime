require "igrf/parser"
require "igrf/parsers/skaters"

module IGRF
  module Parsers
    class Rosters < TeamParser
      def columns
        { :away => { :team_name => 7 },
          :home => { :team_name => 1 } }
      end

      def data
        workbook.extract_data(2)
      end

      def rows
        [7]
      end

      private

      def _parse(row, columns, hash)
        super

        hash[:skaters] = Parsers::Skaters.parse(workbook).parsed.send(hash.keys.first)
        hash
      end
    end
  end
end
