require "igrf/model"

module Igrf
  module Models
    class Jam < Model
      def game
        parent
      end

      def home?
        !!attributes[:home]
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

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :number, :period].include?(key) }}>"
      end
    end
  end
end
