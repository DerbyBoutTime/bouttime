require "igrf/parser"

module IGRF
  module Parsers
    class Venue < Parser
      def columns
        { :city => 7, :name => 1, :state => 9 }
      end

      def data
        workbook.extract_data(2)
      end

      def rows
        [2]
      end
    end
  end
end
