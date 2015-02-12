class WebsocketController < WebsocketRails::BaseController
  before_filter :set_game_state
  before_filter :set_message
  before_filter :set_client_state

  def initialize_session
  end

  private

  def set_game_state
    @game_state = GameState.find(connection_store[:game_state_id])
  end

  def set_message
    @message = message.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end

  def set_client_state
    @client_state = @message[:state]
  end
end
