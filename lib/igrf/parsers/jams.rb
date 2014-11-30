require "igrf/parser"

module IGRF
  module Parsers
    class Jams < TeamParser
      def columns
        { :away => { :number => 0 },
          :home => { :number => 19 } }
      end

      def data
        @data ||= worksheets[3].extract_data
      end

      def parse
        rows.each do |number, hash|
          columns.each do |split, columns|
            _parsed = _parse(data[number], columns, { split => true }.merge(hash || {}))

            if _parsed[:number].is_a?(Integer)
              parsed << _parsed
            elsif _parsed[:number].is_a?(String)
              handle_star_pass(_parsed)
            end
          end
        end

        true
      end

      def rows
        3.upto(36).map { |number| [number, { :period => 1 }] } +
          50.upto(83).map { |number| [number, { :period => 2 }] }
      end

      private

      def handle_star_pass(jam)
        previous_jam = parsed.last
        last_pass = previous_jam[:passes].take_while { |pass| pass[:number] }.last[:number]

        previous_jam[:star_pass] = last_pass
        previous_jam[:passes] += jam[:passes][(last_pass - 1)..-1]
      end

      def _parse(row, columns, hash)
        hash[:passes] = [{ :number => 1 }]
        super
      end
    end
  end
end
