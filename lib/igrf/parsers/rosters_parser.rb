module IGRF
  module Parsers
    class RostersParser < Base
      def parse
        IGRF::Rosters.new(AwayRosterParser.new(game).parse,
                          HomeRosterParser.new(game).parse)
      end
    end
  end
end
