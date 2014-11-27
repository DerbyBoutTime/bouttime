module IGRF
  module Parsers
    class RostersParser < Base
      def parse
        IGRF::Rosters.new(AwayRosterParser.new(data).parse,
                          HomeRosterParser.new(data).parse)
      end
    end
  end
end
