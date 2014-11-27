module IGRF
  module Parsers
    class RosterParser < Base
      def parse
        IGRF::Roster.new(name, league, skaters)
      end
    end

    class AwayRosterParser < RosterParser
      def name
        data[8][7]
      end

      def league
        data[7][7]
      end

      def skaters
        AwaySkatersParser.new(data).parse
      end
    end

    class HomeRosterParser < RosterParser
      def name
        data[8][1]
      end

      def league
        data[7][1]
      end

      def skaters
        HomeSkatersParser.new(data).parse
      end
    end
  end
end
