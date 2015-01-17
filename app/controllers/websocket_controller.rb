class WebsocketController < WebsocketRails::BaseController
  before_filter :set_game_state, except: :set_game_state_id
  before_filter :set_state, except: :set_game_state_id

  def set_game_state_id
    puts event.name, message
    if message[:game_state_id]
      controller_store[:game_state_id] = message[:game_state_id]
      connection_store[:game_state_id] = message[:game_state_id]
    else
      controller_store[:game_state_id] = GameState.last.id
      connection_store[:game_state_id] = GameState.last.id
    end
    puts "Switching to GS##{controller_store[:game_state_id]}"
  end


  private

  def set_game_state
    @game_state = GameState.find(controller_store[:game_state_id])
    # puts "Using gamestate: #{@game_state.id}"
  end

  def set_state
    @state = message[:state].deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end

end
