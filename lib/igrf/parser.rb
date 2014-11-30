module IGRF
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
      rows.each do |row|
        parsed << _parse(row, columns) if row[columns[columns.keys.first]]
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

    def _parse(row, columns, hash = {})
      columns.each do |name, column|
        hash[name] = row[column]
      end

      hash
    end

    def worksheets
      @workbook.worksheets
    end
  end

  class SplitParser < Parser
    def parse
      rows.each do |row|
        columns.each do |split, columns|
          parsed << _parse(row, columns, { split => true }) if row[columns[columns.keys.first]]
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
