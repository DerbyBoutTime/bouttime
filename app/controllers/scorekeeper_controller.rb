class ScorekeeperController < WebsocketController
  def set_jammer
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.skater_number = message["skaterNumber"]
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end
end
