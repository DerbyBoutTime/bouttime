module IGRF
  module Parsers
    class Venue < Parser
      def city
        data[2][7]
      end

      def data
        @data ||= worksheets[2].extract_data
      end

      def name
        data[2][1]
      end

      def parse
        { :city => city, :name => name, :state => state }
      end

      def state
        data[2][9]
      end
    end
  end
end
