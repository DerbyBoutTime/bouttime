module IGRF
  module Parsers
    class OfficialsParser < Base
      def data
        @data ||= @game.workbook.worksheets[2].extract_data
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
          @officials << IGRF::Models::NSO.new(row[1], row[4], row[7], row[10])
        end
      end

      def _parse_referees
        data[31..34].each do |row|
          @officials << IGRF::Models::Referee.new(row[0], row[2], row[3], row[4]) if row[0]
          @officials << IGRF::Models::Referee.new(row[6], row[8], row[9], row[11]) if row[6]
        end
      end
    end
  end
end
