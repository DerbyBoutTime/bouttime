class PenaltyTrackerController < WebsocketController
  def set_penalty
    local_skater, client_skater = get_skater
    client_penalty_state = client_skater[:penalty_states].last
    local_skater.penalty_states.create(
      jam_number: client_penalty_state[:jam_number],
      sort: client_penalty_state[:sort],
      penalty: Penalty.find(client_penalty_state[:penalty][:id])
    )
    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end
  def clear_penalty
    local_skater, client_skater = get_skater
    local_penalty_state = local_skater.penalty_states.find_by(sort: @message[:removed_penalty][:sort])
    local_penalty_state.destroy
    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end
  def update_penalty
    local_penalty_state, client_penalty_state = get_penalty_state
    local_penalty_state.update(
      jam_number: client_penalty_state[:jam_number],
      penalty: Penalty.find(client_penalty_state[:penalty][:id])
    )
    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end
  private
  def get_team
    team_type = @message[:team_type]
    case team_type
    when 'home'
      [@game_state.home, @client_state[:home_attributes]]
    when 'away'
      [@game_state.away, @client_state[:away_attributes]]
    end
  end
  def get_skater
    skater_index = @message[:skater_index]
    local_team, client_team = get_team
    client_skater = client_team[:skater_states][skater_index]
    local_skater = local_team.skater_states.find(client_skater[:id])
    [local_skater, client_skater]
  end
  def get_penalty_state
    penalty_state_index = @message[:penalty_state_index]
    local_skater, client_skater = get_skater
    client_penalty_state = client_skater[:penalty_states][penalty_state_index]
    local_penalty_state = local_skater.penalty_states.find_by(sort: client_penalty_state[:sort])
    [local_penalty_state, client_penalty_state]
  end
end