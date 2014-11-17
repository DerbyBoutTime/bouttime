class Jam < ActiveRecord::Base
  has_one :away_lineup, class_name: "Lineup"
  has_one :home_lineup, class_name: "Lineup"

  has_many :passes
end
