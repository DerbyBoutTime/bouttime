require "igrf/workbook"

module IGRF
  def self.for(file)
    Workbook.new(file).to_game
  end
end

require_relative "igrf/models"
require_relative "igrf/parsers"
