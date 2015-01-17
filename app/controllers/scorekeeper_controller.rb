class ScorekeeperController < WebsocketController

  def toggle_injury
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.injury = !@pass_state.injury
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

  def toggle_calloff
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.calloff = !@pass_state.calloff
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

  def toggle_lost_lead
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.lost_lead = !@pass_state.lost_lead
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

  def set_jammer
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.skater_number = message["skaterNumber"]
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end
end
