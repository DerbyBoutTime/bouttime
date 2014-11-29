module IGRF
  module Parsers
    class Passes < Parser
      attr_reader :jam, :game

      def self.parse(jam)
        new(jam).parse
      end

      def initialize(jam)
        @jam = jam
        @game = jam.game
      end

      def data
        @data ||= worksheets[3].extract_data
      end

      def row_number
        @jam.number + IGRF::Parsers::Jams::PERIODS[@jam.period].first - 1
      end

      def parse
        if @jam.home
          HomePasses.new(@jam).parse
        else
          AwayPasses.new(@jam).parse
        end
      end
    end

    class HomePasses < Passes
      def parse
        data[row_number][7..15].each_with_index.map do |score, i|
          next if score.nil?
          {number: i+2, score: score}
        end.compact
      end
    end

    class AwayPasses < Passes
      def parse
        data[row_number][26..34].each_with_index.map do |score, i|
          next if score.nil?
          {number: i+2, score: score}
        end.compact
      end
    end
  end
end
