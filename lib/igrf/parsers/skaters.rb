require "igrf/parser"

module IGRF
  module Parsers
    class Skaters < TeamParser
      def columns
        { :away => { :name => 8, :number => 7 },
          :home => { :name => 2, :number => 1 } }
      end

      def data
        workbook.extract_data(2)
      end

      def rows
        10..29
      end
    end
  end
end
