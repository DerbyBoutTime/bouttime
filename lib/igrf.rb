module IGRF
  def self.for(file)
    Models::Game.new(file)
  end
end

require_relative "igrf/models"
require_relative "igrf/parsers"
