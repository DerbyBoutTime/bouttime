require "igrf/parser"

module Igrf
  module Parsers
    class Passes < TeamParser
      def columns
        { :away => 26.upto(34).map { |score| { :score => score, :jam_number => 19, :skater_number => 20 } },
          :home => 7.upto(15).map { |score| { :score => score, :jam_number => 0, :skater_number => 1 } } }
      end

      def data
        workbook.extract_data(3)
      end

      def parse
        rows.each do |number, hash|
          columns.each do |team, columns|
            columns.each_with_index do |columns, index|
              _parsed = _parse(data[number], columns, { team => true }.merge(hash || {}))
              _parsed[:number] = index + 2

              if _parsed[:jam_number].is_a?(Integer)
                parsed << _parsed if _parsed[:score]
              elsif _parsed[:jam_number].is_a?(String) && _parsed[:jam_number] == "SP"
                parsed << handle_star_pass(_parsed, previous(number, hash, columns, team)) if _parsed[:score]
              end
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

      def handle_star_pass(pass, previous)
        pass[:jam_number] = previous[:jam_number]
        pass[:star_pass] = true
        pass
      end

      def previous(number, hash, columns, team)
        _parse(data[number - 1], columns, { team => true }.merge(hash || {}))
      end
    end
  end
end
