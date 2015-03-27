class LineupTrackerController < WebsocketRails::BaseController
  before_filter :set_game_state
  before_filter :set_message
  before_filter :set_client_state
  # def update
  #   @game_state.lineup_states.destroy_all
  #   @game_state.update_attributes!(game_state_params)
  #   broadcast_message :update, @game_state.as_json()
  # end
  def toggle_no_pivot
    team_type = @message[:team_type]
    jam_index = @message[:jam_index]
    local_team, client_team = get_team(team_type)
    local_jam, client_jam = get_jam(local_team, client_team, jam_index)
    local_jam.update(no_pivot: client_jam[:no_pivot])
    @game_state.reload
    broadcast_message :update, @game_state.as_json()
  end
  def toggle_star_pass
    team_type = @message[:team_type]
    jam_index = @message[:jam_index]
    local_team, client_team = get_team(team_type)
    local_jam, client_jam = get_jam(local_team, client_team, jam_index)
    local_jam.update(star_pass: client_jam[:star_pass])
    @game_state.reload
    broadcast_message :update, @game_state.as_json()
  end
  def set_skater
    team_type = @message[:team_type]
    jam_index = @message[:jam_index]
    position = @message[:position]
    local_team, client_team = get_team(team_type)
    local_jam, client_jam = get_jam(local_team, client_team, jam_index)
    client_skater = client_jam[position.to_sym]
    local_skater = client_skater ? local_team.skaters.find_by(number: client_skater[:number]) : nil
    case position
    when 'pivot'
      local_jam.pivot = local_skater
    when 'blocker1'
      local_jam.blocker1 = local_skater
    when 'blocker2'
      local_jam.blocker2 = local_skater
    when 'blocker3'
      local_jam.blocker3 = local_skater
    when 'jammer'
      local_jam.jammer = local_skater
    end
    local_jam.save
    @game_state.reload
    broadcast_message :update, @game_state.as_json()
  end
  def set_lineup_status
    team_type = @message[:team_type]
    jam_index = @message[:jam_index]
    status_index = @message[:status_index]
    position = @message[:position]
    local_team, client_team = get_team(team_type)
    local_jam, client_jam = get_jam(local_team, client_team, jam_index)
    client_lineup_status = client_jam[:lineup_statuses][status_index]
    local_lineup_status = local_jam.lineup_statuses.find_by(order: status_index)
    if !local_lineup_status
      local_lineup_status = local_jam.lineup_statuses.create(order: status_index)
    end
    if client_lineup_status #Perform Action
      case position
      when 'pivot'
        local_lineup_status.pivot = client_lineup_status[:pivot]
      when 'blocker1'
        local_lineup_status.blocker1 = client_lineup_status[:blocker1]
      when 'blocker2'
        local_lineup_status.blocker2 = client_lineup_status[:blocker2]
      when 'blocker3'
        local_lineup_status.blocker3 = client_lineup_status[:blocker3]
      when 'jammer'
        local_lineup_status.jammer = client_lineup_status[:jammer]
      end
      local_lineup_status.save
    else #Undo Action
      local_lineup_status.destroy
    end
    @game_state.reload
    broadcast_message :update, @game_state.as_json()
  end
  def end_jam
    team_type = @message[:team_type]
    local_team, client_team = get_team(team_type)
    if client_team[:jam_states].size > local_team.jam_states.size
      client_jam = client_team[:jam_states].last
      attrs = {
        jam_number: client_jam[:jam_number],
        lineup_statuses_attributes: client_jam[:lineup_statuses]
      }
      [:pivot, :blocker1, :blocker2, :blocker3, :jammer].each do |position|
        attrs.merge! position => local_team.skaters.find_by(number: client_jam[position][:number]) if client_jam[position]
      end
      local_team.jam_states.create(attrs)
    else
      local_team.jam_states.last.destroy
    end
    @game_state.reload
    broadcast_message :update, @game_state.as_json()
  end
  private
  def set_game_state
    @game_state = GameState.find(message[:state][:id])
  end
  def set_message
    @message = message.deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end
  def set_client_state
    @client_state = @message[:state]
  end
  def get_local_team(team_type)
    case team_type
    when 'home'
      @game_state.home
    when 'away'
      @game_state.away
    end
  end
  def get_client_team(team_type)
    case team_type
    when 'home'
      @client_state[:home_attributes]
    when 'away'
      @client_state[:away_attributes]
    end
  end
  def get_team(team_type)
    [get_local_team(team_type), get_client_team(team_type)]
  end
  def get_local_jam(local_team, jam_number)
    local_team.jam_states.find_by(jam_number: jam_number)
  end
  def get_client_jam(client_team, jam_index)
    client_team[:jam_states][jam_index]
  end
  def get_jam(local_team, client_team, jam_index)
    client_jam = get_client_jam(client_team, jam_index)
    local_jam = get_local_jam(local_team, client_jam[:jam_number])
    [local_jam, client_jam]
  end
end