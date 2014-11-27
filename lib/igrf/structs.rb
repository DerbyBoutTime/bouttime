module IGRF
  NSO = Struct.new(:name, :position, :league, :cert)
  Referee = Struct.new(:name, :position, :league, :cert)
  Roster = Struct.new(:name, :league, :skaters)
  Rosters = Struct.new(:away, :home)
  Skater = Struct.new(:number, :name)
  Venue = Struct.new(:name, :city, :state)
end
