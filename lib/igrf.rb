module IGRF
  def self.parse(file)
    parser = Parser.new(file)
    parser.parse
    parser
  end
end
