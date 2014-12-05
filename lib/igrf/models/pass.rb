require "igrf/model"

module Igrf
  module Models
    class Pass < Model
      def home?
        !!attributes[:home]
      end

      def jam
        parent
      end

      def star_pass?
        attributes[:star_pass]
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:away, :home, :jam_number, :period, :score, :skater_number, :star_pass].include?(key) }}>"
      end
    end
  end
end
