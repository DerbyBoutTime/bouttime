module IGRF
  module Parsers
    class Officials < Parser
      def data
        @data ||= worksheets[2].extract_data
      end

      def parse
        @officials = []

        _parse_nsos
        _parse_referees

        @officials
      end

      private

      def _parse_nsos
        data[55..75].take_while { |row| row[1] }.each do |row|
          @officials << { :name => row[1], :position => row[4], :league => row[7], :certification => row[10] }
        end
      end

      def _parse_referees
        data[31..34].each do |row|
          @officials << { :name => row[0], :position => row[2], :league => row[3], :certification => row[4] } if row[0]
          @officials << { :name => row[6], :position => row[8], :league => row[9], :certification => row[11] } if row[6]
        end
      end
    end
  end
end
