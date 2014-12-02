require "igrf/model"

module IGRF
  module Models
    class Skater < Model
      def roster
        parent
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :name, :number].include?(key) }}>"
      end
    end
  end
end
