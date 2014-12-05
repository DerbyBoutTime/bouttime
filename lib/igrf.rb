require "igrf/workbook"

module Igrf
  def self.for(file)
    Workbook.new(file).to_game
  end
end

require_relative "igrf/models"
require_relative "igrf/parsers"
