module IGRF
  def self.for(file)
    Models::Game.new(file)
  end
end

require_relative "igrf/model"
require_relative "igrf/parser"
