module IGRF
  module Parsers
    class Base
      attr_reader :game

      def self.parse(game)
        new(game).parse
      end

      def initialize(game)
        @game = game
      end

      def data
      end
    end
  end
end

Dir.glob(File.dirname(__FILE__) + "/parsers/**/*_parser.rb").each do |file|
  require_relative file
end
