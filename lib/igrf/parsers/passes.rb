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
              if _parsed[:jam_number].is_a?(Integer)
                parsed << _parsed if _parsed[:score]
              elsif _parsed[:jam_number].is_a?(String) && _parsed[:jam_number] == "SP"
                parsed << handle_star_pass(_parsed) if _parsed[:score]
              end
            end
          end
        end
        true
      end

      private

      def handle_star_pass(pass)
        team = pass[:home] ? :home : :away
        previous_pass = parsed.select{|item| item[team]}.last
        pass[:jam_number] = previous_pass[:jam_number]
        pass
      end

    end
  end
end
