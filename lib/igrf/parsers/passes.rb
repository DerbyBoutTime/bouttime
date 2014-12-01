require "igrf/parser"

module IGRF
  module Parsers
    class Passes < TeamParser
      def columns
        home = 7.upto(15).map { |score| {:score => score, :jam_number => 0, :skater_number => 1 } }
        away = 26.upto(34).map { |score| {:score => score, :jam_number => 19, :skater_number => 20 } }
        { :home => home, :away => away }
      end

      def data
        @data ||= worksheets[3].extract_data
      end

      def rows
        3.upto(36).map { |number| [number, { :period => 1 }] } +
        50.upto(83).map { |number| [number, { :period => 2 }] }
      end

      # [ { score: 1, jam_number: 1, period: 1, away: true, star_pass: true, skater: 12 } ]
      def parse
        rows.each do |number, hash|
          columns.each do |team, columns|
            columns.each_with_index do |columns, index|
              _parsed = _parse(data[number], columns, { team => true }.merge(hash || {}))
              _parsed[:number] = index+2
              parsed << _parsed
            end
          end
        end
        true
      end

    end

    private

    def handle_star_pass(args)
    end

    def _parse(row, columns, hash)
      super
    end

  end
end
