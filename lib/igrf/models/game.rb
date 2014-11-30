require "rubyXL"
require "igrf/model"

module IGRF
  module Models
    class Game < Model
      attr_reader :workbook

      def initialize(file)
        @workbook = RubyXL::Parser.parse(file)
      end

      def jams
        @jams ||= Jam.for(self)
      end
    end
  end
end
