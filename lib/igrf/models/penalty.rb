require "igrf/model"

module Igrf
  module Models
    class Penalty < Model
      def game
        parent
      end

      def home?
        !!attributes[:home]
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :jam_number, :penalties, :period, :skater_number].include?(key) }}>"
      end
    end
  end
end
