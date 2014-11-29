module IGRF
  module Parsers
    class Skaters < Parser
      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def skaters
        data[10..29]
      end
    end

    class AwaySkaters < Skaters
      def parse
        skaters.take_while { |skater| skater[7] }.map do |skater|
          { :number => skater[7], :name => skater[8] }
        end
      end
    end

    class HomeSkaters < Skaters
      def parse
        skaters.take_while { |skater| skater[1] }.map do |skater|
          { :number => skater[1], :name => skater[2] }
        end
      end
    end
  end
end
