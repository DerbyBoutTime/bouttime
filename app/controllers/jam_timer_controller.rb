class JamTimerController < WebsocketRails::BaseController
  before_filter :set_game_state
  before_filter :set_state
  def initialize_session
    controller_store[:game_state_id] = GameState.last.id
  end

  def jam_tick
    puts event.name, @state[:jam_clock_attributes]
    if @game_state[:jam_clock_attributes] != @state[:jam_clock_attributes]
      @game_state.update_attributes!(@state)
      broadcast_message :update, @game_state.as_json()
    end
  end

  def period_tick
    puts event.name, @state[:period_clock_attributes]
    if @game_state[:period_clock_attributes] != @state[:period_clock_attributes]
      @game_state.update_attributes!(@state)
      broadcast_message :update, @game_state.as_json()
    end
  end

  def start_jam
  end

  def stop_jam
  end

  def start_lineup
  end

  def start_clock
  end

  def stop_clock
  end

  def undo
  end

  def start_timeout
  end

  def restore_official_review
  end

  def mark_as_official_timeout
  end

  def mark_as_home_team_timeout
  end

  def mark_as_home_team_review
  end

  def mark_as_away_team_timeoue
  end

  def mark_as_away_team_review
  end

  def mark_as_ended_by_time
  end

  def mark_as_ended_by_calloff
  end

  private

  def sanitize(klass, attributes)
    attributes.reject{|k,v| !klass.attribute_names.include?(k.to_s) }
  end

  def set_game_state
    @game_state = GameState.find(controller_store[:game_state_id])
  end

  def set_state
    @state = message[:state].deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end
end