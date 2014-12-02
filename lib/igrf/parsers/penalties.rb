require "igrf/parser"

module IGRF
  module Parsers
    class Penalties < TeamParser
      def columns
        { :away => [[{ :skater_number => 0, :penalties => 1..9 }, { :period => 1 }], [{ :skater_number => 28, :penalties => 29..37 }, { :period => 2 }]],
          :home => [[{ :skater_number => 15, :penalties => 16..24 }, { :period => 1 }], [{ :skater_number => 43, :penalties => 44..52 }, { :period => 2 }]] }
      end

      def data
        workbook.extract_data(4)
      end

      def parse
        rows.each do |number|
          columns.each do |team, columns|
            columns.each do |columns, hash|
              _parsed = _parse(data[number], columns, { team => true }.merge(hash || {}))
              _parsed[:penalties] = _parsed[:penalties].compact.each_with_index.map do |penalty, index|
                { :code => penalty, :jam_number => data[number + 1][columns[:penalties].first + index] }
              end

              parsed << _parsed
            end
          end
        end

        true
      end

      def rows
        (3..41).step(2)
      end
    end
  end
end
