class WebsocketController < WebsocketRails::BaseController
  before_filter :set_game_state
  before_filter :set_state

  def initialize_session
  end

  private

  def set_game_state
    @game_state = GameState.find(connection_store[:game_state_id])
  end

  def set_state
    @state = message[:state].deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end

end
