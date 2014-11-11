class ScoreboardController < ApplicationController
  def show
    @home_team_logo_url = params[:home_team_logo_url] || placehold_it(600, 600)
    @away_team_logo_url = params[:away_team_logo_url] || placehold_it(600, 600)
    @home_team_name = params[:home_team_name].to_s || "Atlanta Rollergirls"
    @away_team_name = params[:away_team_name].to_s || "Gotham Rollergirls"
  end

end
