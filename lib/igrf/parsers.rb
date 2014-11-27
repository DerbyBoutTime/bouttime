module IGRF
  module Parsers
    class Base
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def parse
      end
    end
  end
end

Dir.glob(File.dirname(__FILE__) + "/parsers/**/*_parser.rb").each do |file|
  require_relative file
end