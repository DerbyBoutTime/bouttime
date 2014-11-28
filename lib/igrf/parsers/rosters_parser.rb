module IGRF
  module Parsers
    class RostersParser < Base
      def parse
        IGRF::Rosters.new(AwayRosterParser.new(workbook).parse,
                          HomeRosterParser.new(workbook).parse)
      end
    end
  end
end
