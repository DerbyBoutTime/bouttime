require "igrf/model"

module IGRF
  module Models
    class Skater < Model
      def roster
        parent
      end
    end
  end
end
