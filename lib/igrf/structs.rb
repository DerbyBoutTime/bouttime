module IGRF
  Roster = Struct.new(:name, :league, :skaters)
  Rosters = Struct.new(:away, :home)
  Skater = Struct.new(:number, :name)
  Venue = Struct.new(:name, :city, :state)
end
