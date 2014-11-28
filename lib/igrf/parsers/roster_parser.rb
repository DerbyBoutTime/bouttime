module IGRF
  module Parsers
    class RosterParser < Base
      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def parse
        IGRF::Models::Roster.new(name, league, skaters)
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
        AwaySkatersParser.new(game).parse
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
        HomeSkatersParser.new(game).parse
      end
    end
  end
end
