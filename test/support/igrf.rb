require "rubyXL"

module Support
  class IGRF
    def self.file
      @@file ||= File.join("test", "igrf", "samples", "one.xlsx")
    end

    def self.workbook
      @@workbook ||= RubyXL::Parser.parse(file)
    end
  end
end
