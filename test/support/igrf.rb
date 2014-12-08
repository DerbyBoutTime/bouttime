require "igrf/workbook"

module Support
  class Igrf
    def self.file
      @@file ||= File.join(Rails.root, "test", "fixtures", "igrfs", "one.xlsx")
    end

    def self.game
      @@game ||= workbook.to_game
    end

    def self.workbook
      @@workbook ||= ::Igrf::Workbook.new(file)
    end
  end
end
