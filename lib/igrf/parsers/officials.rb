module IGRF
  module Parsers
    class NSOs < Parser
      def columns
        { :name => 1, :position => 4, :league => 7, :certification => 10 }
      end

      def data
        @data ||= worksheets[2].extract_data
      end

      def rows
        data[55..75]
      end
    end

    class Referees < SplitParser
      def columns
        { :first => { :name => 0, :position => 2, :league => 3, :certification => 4 },
          :second => { :name => 6, :position => 8, :league => 9, :certification => 11 } }
      end

      def data
        @data ||= worksheets[2].extract_data
      end

      def rows
        data[31..34]
      end
    end
  end
end
