require "igrf/model"

module IGRF
  module Models
    class Pass < Model
      def jam
        parent
      end

      def star_pass?
        attributes[:star_pass]
      end
    end
  end
end
