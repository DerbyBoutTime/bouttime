module IGRF
  module Parsers
    class SkatersParser < Base
      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def skaters
        data[10..29]
      end
    end

    class AwaySkatersParser < SkatersParser
      def parse
        skaters.take_while { |skater| skater[7] }.map do |skater|
          Skater.new(skater[7], skater[8])
        end
      end
    end

    class HomeSkatersParser < SkatersParser
      def parse
        skaters.take_while { |skater| skater[1] }.map do |skater|
          Skater.new(skater[1], skater[2])
        end
      end
    end
  end
end
