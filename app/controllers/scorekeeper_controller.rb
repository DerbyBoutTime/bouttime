class ScorekeeperController < WebsocketController
  def new_jam
    local_team, client_team = get_team
    client_jam = client_team[:jam_states].last
    attrs = {
      jam_number: client_jam[:jam_number],
      pass_states_attributes: client_jam[:pass_states]
    }
    local_team.jam_states.create attrs

    @game_state.update jam_number: @client_state[:jam_number]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def new_pass
    local_jam, client_jam = get_jam
    local_jam.pass_states.create client_jam[:pass_states].last

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def set_points
    local_pass, client_pass = get_pass
    local_pass.update points: client_pass[:points].to_i

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def set_pass_number
    local_pass, client_pass = get_pass
    local_pass.update pass_number: client_pass[:pass_number]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def set_skater_number
    local_pass, client_pass = get_pass
    local_pass.update skater_number: client_pass[:skater_number]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def toggle_nopass
    local_pass, client_pass = get_pass
    local_pass.update nopass: client_pass[:nopass]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def toggle_lead
    local_pass, client_pass = get_pass
    local_pass.update lead: client_pass[:lead]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def toggle_injury
    local_pass, client_pass = get_pass
    local_pass.update injury: client_pass[:injury]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def toggle_calloff
    local_pass, client_pass = get_pass
    local_pass.update calloff: client_pass[:calloff]

    @game_state.reload
    broadcast_message :update, @game_state.as_json
  end

  def toggle_lost_lead
    local_pass, client_pass = get_pass
    local_pass.update lost_lead: client_pass[:lost_lead]

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

  def get_jam
    jam_index = @message[:jam_index]
    local_team, client_team = get_team

    client_jam = client_team[:jam_states][jam_index]
    local_jam = local_team.jam_states.find_by(jam_number: client_jam[:jam_number])

    [local_jam, client_jam]
  end

  def get_pass
    pass_index = @message[:pass_index]
    local_jam, client_jam = get_jam
    client_pass = client_jam[:pass_states][pass_index]
    local_pass = local_jam.pass_states.find_by(sort: client_pass[:sort])

    [local_pass, client_pass]
  end
end
