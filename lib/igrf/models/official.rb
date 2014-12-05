require "igrf/model"

module Igrf
  module Models
    class Official < Model
      def game
        parent
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:certification, :league, :name, :position].include?(key) }}>"
      end
    end
  end
end
