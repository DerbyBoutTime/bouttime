module IGRF::Models
  class Base
  end
end

Dir.glob(File.dirname(__FILE__) + "/models/**/*.rb").each do |file|
  require_relative file
end
