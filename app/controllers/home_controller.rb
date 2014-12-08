class HomeController < ApplicationController
  def index
  end

  def jam_timer
    @active_class = "jam_timer"
  end

  def lineup_tracker
    @active_class = "lineup_tracker"
  end

  def penalty_box
    @active_class = "penalty_box"
  end

  def penalty_tracker
    @active_class = "penalty_tracker"
  end

  def scorekeeper
    @active_class = "scorekeeper"
  end

  def scoreboard
    @active_class = "scoreboard"
    @hide_nav = true
    @home_team_logo_url = params[:home_team_logo_url] || placehold_it(600, 600)
    @away_team_logo_url = params[:away_team_logo_url] || placehold_it(600, 600)
    @home_team_name = params[:home_team_name].to_s || "Atlanta Rollergirls"
    @away_team_name = params[:away_team_name].to_s || "Gotham Rollergirls"
  end

  def penalty_whiteboard
    @active_class = "penalty_whiteboard"
    @hide_nav = true
  end

  def announcer
    @active_class = "announcer"
    @hide_nav = true
  end

  def global_bout_notes
    @active_class = "global_bout_notes"
  end

  private

  def placehold_it(width, height, text = "")
    "http://placehold.it/#{width}x#{height}&text=#{text}+(#{width}x#{height})"
  end
end
