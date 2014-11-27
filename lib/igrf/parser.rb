require "rubyXL"

module IGRF
  Roster = Struct.new(:name, :league, :skaters)
  Skater = Struct.new(:number, :name)
  Rosters = Struct.new(:away, :home)
  Venue = Struct.new(:name, :city, :state)

  class Parser
    attr_reader :venue, :workbook

    def initialize(file)
      @workbook = RubyXL::Parser.parse(file)
      @worksheet_data = {}
    end

    def rosters
      @rosters ||= Parsers::RostersParser.new(data_for_worksheet(2)).parse
    end

    def venue
      @venue ||= Parsers::VenueParser.new(data_for_worksheet(2)).parse
    end

    private

    def data_for_worksheet(number)
      @worksheet_data[number] ||= @workbook.worksheets[number].extract_data
    end
  end

  module Parsers
    class Base
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def parse
      end
    end

    class RosterParser < Base
      def parse
        IGRF::Roster.new(name, league, skaters)
      end
    end

    class AwayRosterParser < RosterParser
      def name
        data[8][7]
      end

      def league
        data[7][7]
      end

      def skaters
        AwaySkatersParser.new(data).parse
      end
    end

    class HomeRosterParser < RosterParser
      def name
        data[8][1]
      end

      def league
        data[7][1]
      end

      def skaters
        HomeSkatersParser.new(data).parse
      end
    end

    class RostersParser < Base
      def parse
        IGRF::Rosters.new(AwayRosterParser.new(data).parse,
                          HomeRosterParser.new(data).parse)
      end
    end

    class SkatersParser < Base
      def skaters
        data[10..29]
      end
    end

    class AwaySkatersParser < SkatersParser
      def parse
        skaters.take_while { |skater| skater[7] }.map do |skater|
          Skater.new(skater[7], skater[8])
        end
      end
    end

    class HomeSkatersParser < SkatersParser
      def parse
        skaters.take_while { |skater| skater[1] }.map do |skater|
          Skater.new(skater[1], skater[2])
        end
      end
    end

    class VenueParser < Base
      def parse
        IGRF::Venue.new(name, city, state)
      end

      def name
        data[2][1]
      end

      def city
        data[2][7]
      end

      def state
        data[2][9]
      end
    end
  end
end
