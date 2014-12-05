require "active_support/core_ext/object/blank"

module Igrf
  class Parser
    attr_reader :workbook

    def self.parse(workbook)
      parser = new(workbook)
      parser.parse
      parser
    end

    def initialize(workbook)
      @workbook = workbook
    end

    def columns
      {}
    end

    def data
      []
    end

    def parse
      rows.each do |number, hash|
        parsed << _parse(data[number], columns, (hash || {})) if data[number][columns[columns.keys.first]].present?
      end

      true
    end

    def parsed
      @parsed ||= []
    end

    def rows
      []
    end

    private

    def _parse(row, columns, hash)
      columns.each do |name, column|
        hash[name] = row[column]
      end

      hash
    end

    def worksheets
      workbook.worksheets
    end
  end

  class SplitParser < Parser
    def parse
      rows.each do |number, hash|
        columns.each do |split, columns|
          parsed << _parse(data[number], columns, { split => true }.merge(hash || {})) if data[number][columns[columns.keys.first]].present?
        end
      end

      true
    end
  end

  class TeamParser < SplitParser
    class TeamArray < Array
      def away
        select { |item| item[:away] }
      end

      def home
        select { |item| item[:home] }
      end
    end

    def parsed
      @parsed ||= TeamArray.new
    end
  end
end
