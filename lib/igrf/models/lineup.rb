require "igrf/model"

module IGRF
  module Models
    class Lineup < Model
      def jam
        parent
      end
    end
  end
end
