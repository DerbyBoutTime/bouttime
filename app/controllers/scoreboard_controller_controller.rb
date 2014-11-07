class ScoreboardControllerController < ApplicationController
  def show
    @home_team_name = "Atlanta Rollergirls"
    @away_team_name = "Gotham Rollergirls"
    @home_team_points = 0
    @away_team_points = 0
    @home_team_jammer = "504\t|\tNattie Long Legs"
    @away_team_jammer = "340\t|\tBonnie Thunders"
  end
end
