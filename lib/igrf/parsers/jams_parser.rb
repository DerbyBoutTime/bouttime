module IGRF
  module Parsers
    class JamsParser < Base
      def data
        @data ||= workbook.worksheets[3].extract_data
      end

      def parse
        @jams = []

        periods.each do |number, rows|
          data[rows].each do |row|
            next if row[0].nil?

            if row[0].is_a?(String)
              # potential to append previous jam, as per SP
            else
              @jams << IGRF::Jam.new(row[0], number)
            end
          end
        end

        @jams
      end

      def periods
        { 1 => 3..36, 2 => 50..83 }
      end
    end
  end
end
