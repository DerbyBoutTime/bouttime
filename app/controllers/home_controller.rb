class HomeController < ApplicationController
  before_action :init_game_state!
  def index
    @initial_props = @game_state.to_json
  end
  private
  def init_game_state!
    reset_session
    if params[:game_state_id]
      session[:game_state_id] = params[:game_state_id]
    end
    if session[:game_state_id].nil?
      gs = GameState.demo!
      session[:game_state_id] = gs.id
    end
    @game_state = GameState.find session[:game_state_id]
  end
  def placehold_it(width, height, text = "")
    "http://placehold.it/#{width}x#{height}&text=#{text}+(#{width}x#{height})"
  end
end
