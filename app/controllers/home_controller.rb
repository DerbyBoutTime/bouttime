class HomeController < ApplicationController
  def index
  end

  def jam_timer
    @active_class = "jam_timer"
    @json = {
      jamTimerState: "TIME_TO_DERBY",
      jamNumber: 1,
      periodNumber: 1,
      jamClockLabel: "Time to derby",
      jamClock: "90:00",
      periodClock: "30:00",
      teams: {
        home: {
          initials: "ARG",
          hasOfficialReview: true,
          isTakingOfficialReview: false,
          timeouts: 3,
          colorBarStyle: {
            backgroundColor: "#2082a6"
          }
        },
        away: {
          initials: "GRG",
          hasOfficialReview: true,
          isTakingOfficialReview: false,
          timeouts: 3,
          colorBarStyle: {
            backgroundColor: "#f50031"
          }
        }
      }
    }.to_json
  end

  def lineup_tracker
    @active_class = "lineup_tracker"
  end

  def penalty_box_timer
    @active_class = "penalty_box_timer"
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

  def announcers_feeds
    @active_class = "announcers_feed"
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
