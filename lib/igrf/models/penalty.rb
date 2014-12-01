require "igrf/model"

module IGRF
  module Models
    class Penalty < Model
      def game
        parent
      end
    end
  end
end
