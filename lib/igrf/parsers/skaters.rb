module IGRF
  module Parsers
    class Skaters < Parser
      def initialize(game)
        raise "Please use Parsers::AwaySkaters or Parsers::HomeSkaters"
      end

      def columns
      end

      def data
        @data ||= @game.workbook.worksheets[2].extract_data
      end

      def parse
        skaters.take_while { |skater| skater[columns[:number]] }.map do |skater|
          { :number => skater[columns[:number]], :name => skater[columns[:name]] }
        end
      end

      def skaters
        data[10..29]
      end
    end

    class AwaySkaters < Skaters
      def columns
        { :name => 8, :number => 7 }
      end
    end

    class HomeSkaters < Skaters
      def columns
        { :name => 2, :number => 1 }
      end
    end
  end
end
