module IGRF
  module Parsers
    class RefereesParser < Base
      def parse
        @referees = []

        rows.each do |row|
          @referees << IGRF::Referee.new(row[0], row[2], row[3], row[4]) if row[0]
          @referees << IGRF::Referee.new(row[6], row[8], row[9], row[11]) if row[6]
        end

        @referees
      end

      def rows
        data[31..34]
      end
    end
  end
end
