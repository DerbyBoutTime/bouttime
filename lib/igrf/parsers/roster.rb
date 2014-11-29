module IGRF
  module Parsers
    class Roster < Parser
      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def parse
        { :name => name, :league => league, :skaters => skaters }
      end
    end

    class AwayRoster < Roster
      def league
        data[7][7]
      end

      def name
        data[8][7]
      end

      def skaters
        AwaySkaters.new(game).parse
      end
    end

    class HomeRoster < Roster
      def league
        data[7][1]
      end

      def name
        data[8][1]
      end

      def skaters
        HomeSkaters.new(game).parse
      end
    end
  end
end
