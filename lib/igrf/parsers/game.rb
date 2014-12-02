require "igrf/parser"
require "igrf/parsers/jams"
require "igrf/parsers/officials"
require "igrf/parsers/penalties"
require "igrf/parsers/rosters"
require "igrf/parsers/venue"

module IGRF
  module Parsers
    class Game < Parser
      def columns
        { :date => 1, :start_time => 7, :end_time => 10 }
      end

      def data
        workbook.extract_data(2)
      end

      def rows
        [4]
      end

      private

      def _parse(row, columns, hash)
        super

        hash[:start_time] = Time.new(hash[:date].year, hash[:date].month, hash[:date].day, hash[:start_time].hour, hash[:start_time].min)
        hash[:end_time] = Time.new(hash[:date].year, hash[:date].month, hash[:date].day, hash[:end_time].hour, hash[:end_time].min)
        hash[:jams] = Parsers::Jams.parse(workbook).parsed
        hash[:officials] = Parsers::NSOs.parse(workbook).parsed + Parsers::Referees.parse(workbook).parsed
        hash[:penalties] = Parsers::Penalties.parse(workbook).parsed
        hash[:rosters] = Parsers::Rosters.parse(workbook).parsed
        hash[:venue] = Parsers::Venue.parse(workbook).parsed.first
        hash
      end
    end
  end
end
