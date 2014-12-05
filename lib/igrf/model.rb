module Igrf
  class Model
    attr_reader :attributes, :parent

    def initialize(attributes, parent = nil)
      @attributes = attributes
      @parent = parent
    end

    def method_missing(method, *args, &block)
      if attributes.has_key?(method)
        attributes[method]
      else
        super
      end
    end
  end
end
