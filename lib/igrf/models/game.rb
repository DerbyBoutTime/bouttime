require "igrf/model"

require "igrf/models/jam"
require "igrf/models/official"
require "igrf/models/penalty"
require "igrf/models/roster"
require "igrf/models/venue"

module Igrf
  module Models
    class Game < Model
      def jams
        @jams ||= attributes[:jams].map { |jam| Jam.new(jam, self) }
      end

      def officials
        @officials ||= attributes[:officials].map { |official| Official.new(official, self) }
      end

      def penalties
        @penalties ||= attributes[:penalties].map { |penalty| Penalty.new(penalty, self) }
      end

      def rosters
        @rosters ||= attributes[:rosters].map { |roster| Roster.new(roster, self) }
      end

      def venue
        @venue ||= Venue.new(attributes[:venue])
      end

      def inspect
        "<#{self.class}: @attributes=#{attributes.select { |key, value| [:end_time, :start_time].include?(key) }}>"
      end
    end
  end
end
