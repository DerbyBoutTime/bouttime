require "igrf/model"

module IGRF
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
