require "igrf/model"

module IGRF
  module Models
    class Official < Model
      def game
        parent
      end
    end
  end
end
