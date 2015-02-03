class LineupTrackerController < WebsocketRails::BaseController
  before_filter :set_game_state
  before_filter :set_state
  def initialize
  end

  def update
    @game_state.lineup_states.destroy_all
    @game_state.update_attributes!(game_state_params)
    broadcast_message :update, @game_state.as_json()
  end

  private

  def set_game_state
    puts "lineup_tracker#set_game_state"
    @game_state = GameState.find(message[:state][:id])
  end

  def set_state
    puts "lineup_tracker#set_state"
    @state = message[:state].deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end

  def team_state_attributes_params
  	[
		:no_pivot,
		:star_pass,
		:pivot_number,
		:blocker1_number,
		:blocker2_number,
		:blocker3_number,
		:jammer_number,
		{ :lineup_status_states_attributes => [
			:pivot,
			:blocker1,
			:blocker2, 
			:blocker3,
			:jammer
		]}
	]
  end

  def game_state_params
    params = ActionController::Parameters.new(@state)
  	params.require(:game_state).permit(:lineup_states_attributes => [
  		:jam_number,
  		:jam_ended,
  		{ 
  			:home_state_attributes => team_state_attributes_params,
  			:away_state_attributes => team_state_attributes_params
  		}
  	])
  end
end