module IGRF
  module Parsers
    class JamsParser < Base
      def data
        @data ||= @game.workbook.worksheets[3].extract_data
      end

      def parse
        @jams = []

        periods.each do |number, rows|
          data[rows].each do |row|
            next if row[0].nil?

            if row[0].is_a?(String)
              # potential to append previous jam, as per SP
            else
              @jams << { :period => number, :number => row[0], :lineup => home_lineup_for_jam(row[0]) }
              @jams << { :period => number, :number => row[19], :lineup => away_lineup_for_jam(row[18]) }
            end
          end
        end

        @jams
      end

      def periods
        { 1 => 3..36, 2 => 50..83 }
      end

      def home_lineup_for_jam(number)
        # HomeLineupsParser.for(game)
      end

      def away_lineup_for_jam(number)
        # AwayLineupsParser.for(game)
      end
    end
  end
end
