module IGRF
  module Parsers
    class VenueParser < Base
      def city
        data[2][7]
      end

      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def name
        data[2][1]
      end

      def parse
        IGRF::Venue.new(name, city, state)
      end

      def state
        data[2][9]
      end
    end
  end
end
