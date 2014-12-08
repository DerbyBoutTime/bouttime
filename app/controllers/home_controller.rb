class HomeController < ApplicationController
  before_action :init_game_state
  def index
  end

  def jam_timer
    @active_class = "jam_timer"
    @props = @game_state.to_json
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
    @props = @game_state.to_json
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

  def init_game_state
    if session[:game_state_id].nil?
      gs = GameState.new
      gs.init_demo!
      session[:game_state_id] = gs.id
    end
    @game_state = GameState.find session[:game_state_id]
  end

  def placehold_it(width, height, text = "")
    "http://placehold.it/#{width}x#{height}&text=#{text}+(#{width}x#{height})"
  end
end
