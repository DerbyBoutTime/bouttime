module IGRF
  module Parsers
    class RosterParser < Base
      def data
        @data ||= workbook.worksheets[2].extract_data
      end

      def parse
        IGRF::Roster.new(name, league, skaters)
      end
    end

    class AwayRosterParser < RosterParser
      def league
        data[7][7]
      end

      def name
        data[8][7]
      end

      def skaters
        AwaySkatersParser.new(workbook).parse
      end
    end

    class HomeRosterParser < RosterParser
      def league
        data[7][1]
      end

      def name
        data[8][1]
      end

      def skaters
        HomeSkatersParser.new(workbook).parse
      end
    end
  end
end
