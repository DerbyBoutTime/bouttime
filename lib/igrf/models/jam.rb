require "igrf/model"

module IGRF
  module Models
    class Jam < Model
      def game
        parent
      end

      def lineup
        @lineup ||= Lineup.new(attributes[:lineup], self)
      end

      def passes
        @passes ||= attributes[:passes].map { |pass| Pass.new(pass, self) }
      end

      def star_pass?
        passes.find { |pass| pass.star_pass? }
      end
    end
  end
end
