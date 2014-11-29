module IGRF
  module Models
    class Pass < Model
      attr_accessor :jam

      def self.for(jam)
        Parsers::Passes.parse(jam).map do |hash|
          pass = new(hash)
          pass.jam = jam
          pass
        end
      end
    end
  end
end
