class ScorekeeperController < WebsocketController
  def set_team_points
    team = message["team"] == "home" ? @game_state.home : @game_state.away
    team.points = message["points"]
    team.save!

    broadcast_message :update, @game_state.as_json
  end

  def set_points
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.points = message["points"].to_i
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

  def toggle_nopass
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.nopass = !@pass_state.nopass
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

  def toggle_lead
    @pass_state = @game_state.find_or_initialize_pass_state_by(message)
    @pass_state.lead = !@pass_state.lead
    @pass_state.save!

    broadcast_message :update, @game_state.as_json
  end

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
