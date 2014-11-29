module IGRF
  module Parsers
    class Rosters < Parser
      def parse
        { :away => AwayRoster.new(game).parse,
          :home => HomeRoster.new(game).parse }
      end
    end
  end
end
