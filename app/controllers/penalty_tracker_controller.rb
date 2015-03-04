class PenaltyTrackerController < WebsocketController

  def update_penalties
    local_skater, client_skater = get_skater
    client_skater[:penalty_states].each do |penalty_state|
      local_penalty = PenaltyState.find_or_initialize_by(sort: penalty_state[:sort])
      attrs = {
        jam_number: penalty_state[:jam_number],
        skater_state: local_skater,
        penalty: Penalty.find(penalty_state[:penalty][:id])
      }

      local_penalty.update attrs
    end

    client_slots = client_skater[:penalty_states].map{|ps| ps[:sort]}

    local_skater.penalty_states.each do | penalty_state|
      penalty_state.destroy if !client_slots.include? penalty_state.sort
    end

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
end