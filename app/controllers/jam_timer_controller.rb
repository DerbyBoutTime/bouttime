class JamTimerController < WebsocketRails::BaseController
  before_filter :set_game_state, except: :set_game_state_id
  before_filter :set_state, except: :set_game_state_id
  def initialize_session
  end

  def set_game_state_id
    puts event.name, message
    if message[:game_state_id]
      controller_store[:game_state_id] = message[:game_state_id]
      connection_store[:game_state_id] = message[:game_state_id]
    else
      controller_store[:game_state_id] = GameState.last.id
      connection_store[:game_state_id] = GameState.last.id
    end
    puts "Switching to GS##{controller_store[:game_state_id]}"
  end

  def jam_tick
    #puts "#{event.name} for GS##{@game_state.id}", @state[:jam_clock_attributes]
    @game_state.update_attributes! jam_clock_attributes: @state[:jam_clock_attributes]
    broadcast_message :update, @game_state.as_json()
  end

  def period_tick
    #puts "#{event.name} for GS##{@game_state.id}", @state[:period_clock_attributes]
    @game_state.update_attributes! period_clock_attributes: @state[:period_clock_attributes]
    broadcast_message :update, @game_state.as_json()
  end

  def start_jam
    attrs = {
      state: @state[:state],
      jam_number: @state[:jam_number],
      period_number: @state[:period_number],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
        jam_points: @state[:home_attributes][:jam_points]
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
        jam_points: @state[:away_attributes][:jam_points]
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def stop_jam
    attrs = {
      state: @state[:state],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
        jammer_attributes: {
          id: @state[:home_attributes][:jammer_attributes][:id],
          name: @state[:home_attributes][:jammer_attributes][:name],
          number: @state[:home_attributes][:jammer_attributes][:number],
          is_lead: @state[:home_attributes][:jammer_attributes][:is_lead]
        }
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
        jammer_attributes: {
          id: @state[:away_attributes][:jammer_attributes][:id],
          name: @state[:away_attributes][:jammer_attributes][:name],
          number: @state[:away_attributes][:jammer_attributes][:number],
          is_lead: @state[:away_attributes][:jammer_attributes][:is_lead]
        }
      }
    }
    puts "#{event.name} for GS##{@game_state.id}"
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def start_lineup
    attrs = {
      state: @state[:state],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
        jammer_attributes: {
          id: @state[:home_attributes][:jammer_attributes][:id],
          name: @state[:home_attributes][:jammer_attributes][:name],
          number: @state[:home_attributes][:jammer_attributes][:number],
          is_lead: @state[:home_attributes][:jammer_attributes][:is_lead]
        }
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
        jammer_attributes: {
          id: @state[:away_attributes][:jammer_attributes][:id],
          name: @state[:away_attributes][:jammer_attributes][:name],
          number: @state[:away_attributes][:jammer_attributes][:number],
          is_lead: @state[:away_attributes][:jammer_attributes][:is_lead]
        }
      }
    }
    puts "#{event.name} for GS##{@game_state.id}"
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  # def start_clock
  #   attrs = {}
  #   puts "#{event.name} for GS##{@game_state.id}"
  #   @game_state.update_attributes!(attrs)
  #   broadcast_message :update, @game_state.as_json()
  # end

  # def stop_clock
  #   attrs = {}
  #   puts "#{event.name} for GS##{@game_state.id}"
  #   @game_state.update_attributes!(attrs)
  #   broadcast_message :update, @game_state.as_json()
  # end

  def undo
  end

  def start_timeout
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def restore_official_review
  end

  def mark_as_official_timeout
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
      jam_clock_attributes: {
        id: @state[:jam_clock_attributes][:id],
        time: @state[:jam_clock_attributes][:time],
        display: @state[:jam_clock_attributes][:display]
      },
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def mark_as_home_team_timeout
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def mark_as_home_team_review
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def mark_as_away_team_timeout
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
  end

  def mark_as_away_team_review
    attrs = {
      state: @state[:state],
      timeout: @state[:timeout],
      home_attributes: {
        id: @state[:home_attributes][:id],
        timeouts: @state[:home_attributes][:timeouts],
        is_taking_timeout: @state[:home_attributes][:is_taking_timeout],
        has_official_review: @state[:home_attributes][:has_official_review],
        is_taking_official_review: @state[:home_attributes][:is_taking_official_review],
      },
      away_attributes: {
        id: @state[:away_attributes][:id],
        timeouts: @state[:away_attributes][:timeouts],
        is_taking_timeout: @state[:away_attributes][:is_taking_timeout],
        has_official_review: @state[:away_attributes][:has_official_review],
        is_taking_official_review: @state[:away_attributes][:is_taking_official_review],
      }
    }
    puts "#{event.name} for GS##{@game_state.id}", attrs
    @game_state.update_attributes!(attrs)
    broadcast_message :update, @game_state.as_json()
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
    # puts "Using gamestate: #{@game_state.id}"
  end

  def set_state
    @state = message[:state].deep_transform_keys{ |key| key.to_s.underscore.to_sym }
  end
end