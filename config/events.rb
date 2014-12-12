WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  subscribe :client_connected, 'event_log#client_connected'
  subscribe :client_disconnected, 'event_log#client_disconnected'

  namespace :jam_timer do
    #subscribe :jam_tick, 'event_log#print'
    subscribe :jam_tick, 'jam_timer#jam_tick'
    #subscribe :period_tick, 'event_log#print'
    subscribe :start_jam, 'event_log#log'
    subscribe :stop_jam, 'event_log#log'
    subscribe :start_lineup, 'event_log#log'
    subscribe :start_clock, 'event_log#log'
    subscribe :stop_clock, 'event_log#log'
    subscribe :undo, 'event_log#log'
    subscribe :start_timeout, 'event_log#log'
    subscribe :restore_official_review, 'event_log#log'
    #subscribe :set_timeout_state
    subscribe :mark_as_official_timeout, 'event_log#log'
    subscribe :mark_as_home_team_timeout, 'event_log#log'
    subscribe :mark_as_home_team_review, 'event_log#log'
    subscribe :mark_as_away_team_timeout, 'event_log#log'
    subscribe :mark_as_away_team_review, 'event_log#log'
    #subscribe :set_jam_state
    subscribe :mark_as_ended_by_time, 'event_log#log'
    subscribe :mark_as_ended_by_calloff, 'event_log#log'
  end

  namespace :scorekeeper do
    subscribe :toggle_lead, 'event_log#log'
    subscribe :toggle_lost_lead, 'event_log#log'
    subscribe :toggle_injury, 'event_log#log'
    subscribe :toggle_nopass, 'event_log#log'
    subscribe :toggle_calloff, 'event_log#log'
    subscribe :set_points, 'event_log#log'
    subscribe :set_jammer, 'event_log#log'
  end

  namespace :lineup_tracker do
    subscribe :toggle_star_pass, 'event_log#log'
    subscribe :toggle_pivot, 'event_log#log'
    subscribe :set_jammer, 'event_log#log'
    subscribe :set_pivot, 'event_log#log'
    subscribe :set_blocker, 'event_log#log'
    subscribe :set_skater_state, 'event_log#log'
  end

  namespace :penalty_tracker do
    subscribe :set_penalty, 'event_log#log'
    subscribe :clear_penalaty, 'event_log#log'
    subscribe :update_penalty, 'event_log#log'
  end

  namespace :penalty_box_timer do
    subscribe :set_skater, 'event_log#log'
    subscribe :mark_as_served, 'event_log#log'
    subscribe :mark_as_left_early, 'event_log#log'
    subscribe :set_sit_time, 'event_log#log'
    subscribe :set_release_time, 'event_log#log'
    subscribe :toggle_timer, 'event_log#log'
  end

  namespace :head_nso do
    subscribe :set_home_team, 'event_log#log'
    subscribe :set_away_team, 'event_log#log'
    subscribe :set_home_team_color, 'event_log#log'
    subscribe :set_away_team_color, 'event_log#log'
    subscribe :set_home_team_text_color, 'event_log#log'
    subscribe :set_away_team_text_color, 'event_log#log'
    subscribe :set_officials_roster, 'event_log#log'
    subscribe :set_home_team_roster, 'event_log#log'
    subscribe :set_away_team_roster, 'event_log#log'
    subscribe :set_venue, 'event_log#log'
    subscribe :set_game_date, 'event_log#log'
  end

  namespace :scoreboard do
    #subscribe :heart_beat, 'event_log#log'
  end

  namespace :penalty_whiteboard do
    #subscribe :heart_beat, 'event_log#log'
  end

  namespace :announcers_feed do
    #subscribe :heart_beat, 'event_log#log'
  end

  namespace :global_bout_notes do
    subscribe :add_note, 'event_log#log'
    subscribe :update_note, 'event_log#log'
    subscribe :delete_note, 'event_log#log'
  end
end
