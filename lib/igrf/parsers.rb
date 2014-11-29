module IGRF
  module Parsers
  end
end

Dir.glob(File.dirname(__FILE__) + "/parsers/**/*.rb").each do |file|
  require_relative file
end
