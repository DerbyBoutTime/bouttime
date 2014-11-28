module IGRF
  Jam = Struct.new(:number, :period) do
    def self.find_by_number_and_period(game, number, period)
      game.jams.find { |jam| jam.number == number && jam.period == period }
    end
  end
  Game = Struct.new(:jams, :officials, :rosters, :venue)
  NSO = Struct.new(:name, :position, :league, :cert)
  Referee = Struct.new(:name, :position, :league, :cert)
  Roster = Struct.new(:name, :league, :skaters)
  Rosters = Struct.new(:away, :home)
  Skater = Struct.new(:number, :name)
  Venue = Struct.new(:name, :city, :state)
end
