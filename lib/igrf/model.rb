module IGRF
  class Model
    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(method, *args, &block)
      if @attributes.has_key?(method)
        @attributes[method]
      else
        super
      end
    end
  end
end

require_relative "models"
