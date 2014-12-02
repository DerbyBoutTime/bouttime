require "igrf/model"

module IGRF
  module Models
    class Penalty < Model
      def game
        parent
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :penalties, :period, :skater_number].include?(key) }}>"
      end
    end
  end
end
