module IGRF
  module Parsers
    class Jams < Parser
      PERIODS = { 1 => 3..36, 2 => 50..83 }.freeze

      def data
        @data ||= worksheets[3].extract_data
      end

      def parse
        @jams = []

        PERIODS.each do |number, rows|
          data[rows].each do |row|
            next if row[0].nil?

            if row[0].is_a?(String)
              # potential to append previous jam, as per SP
            else
              @jams << { :period => number, :number => row[0], :home => true }
              @jams << { :period => number, :number => row[19], :home => false }
            end
          end
        end

        @jams
      end
    end
  end
end
