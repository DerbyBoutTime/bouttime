module IGRF
  module Parsers
    class VenueParser < Base
      def parse
        IGRF::Venue.new(name, city, state)
      end

      def name
        data[2][1]
      end

      def city
        data[2][7]
      end

      def state
        data[2][9]
      end
    end
  end
end
