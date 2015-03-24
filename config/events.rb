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
    subscribe :set_game_state_id, 'jam_timer#set_game_state_id'
    subscribe :jam_tick, 'jam_timer#jam_tick'
    #subscribe :jam_tick, 'event_log#print'
    subscribe :period_tick, 'jam_timer#period_tick'
    #subscribe :period_tick, 'event_log#print'
    subscribe :start_jam, 'jam_timer#start_jam'
    #subscribe :start_jam, 'event_log#log'
    subscribe :stop_jam, 'jam_timer#stop_jam'
    #subscribe :stop_jam, 'event_log#log'
    subscribe :start_lineup, 'jam_timer#start_lineup'
    #subscribe :start_lineup, 'event_log#log'
    subscribe :start_clock, 'event_log#log'
    subscribe :stop_clock, 'event_log#log'
    subscribe :undo, 'event_log#log'
    subscribe :start_timeout, 'jam_timer#start_timeout'
    #subscribe :start_timeout, 'event_log#log'
    subscribe :restore_official_review, 'jam_timer#restore_official_review'
    #subscribe :restore_official_review, 'event_log#log'
    #subscribe :set_timeout_state
    subscribe :mark_as_official_timeout, 'jam_timer#mark_as_official_timeout'
    #subscribe :mark_as_official_timeout, 'event_log#log'
    subscribe :mark_as_home_team_timeout, 'jam_timer#mark_as_home_team_timeout'
    #subscribe :mark_as_home_team_timeout, 'event_log#log'
    subscribe :mark_as_home_team_review, 'jam_timer#mark_as_home_team_review'
    #subscribe :mark_as_home_team_review, 'event_log#log'
    subscribe :mark_as_away_team_timeout, 'jam_timer#mark_as_away_team_timeout'
    #subscribe :mark_as_away_team_timeout, 'event_log#log'
    subscribe :mark_as_away_team_review, 'jam_timer#mark_as_away_team_review'
    #subscribe :mark_as_away_team_review, 'event_log#log'
    #subscribe :set_jam_state
    subscribe :mark_as_ended_by_time, 'event_log#log'
    subscribe :mark_as_ended_by_calloff, 'event_log#log'
  end

  namespace :scorekeeper do
    subscribe :toggle_lead, 'scorekeeper#toggle_lead'
    subscribe :toggle_lost_lead, 'scorekeeper#toggle_lost_lead'
    subscribe :toggle_injury, 'scorekeeper#toggle_injury'
    subscribe :toggle_nopass, 'scorekeeper#toggle_nopass'
    subscribe :toggle_calloff, 'scorekeeper#toggle_calloff'
    subscribe :set_points, 'scorekeeper#set_points'
    subscribe :reorder_pass, 'scorekeeper#reorder_pass'
    subscribe :new_jam, 'scorekeeper#new_jam'
    subscribe :new_pass, 'scorekeeper#new_pass'
    subscribe :set_skater_number, 'scorekeeper#set_skater_number'
  end

  namespace :lineup_tracker do
    subscribe :toggle_star_pass, 'lineup_tracker#toggle_star_pass'
    subscribe :toggle_no_pivot, 'lineup_tracker#toggle_no_pivot'
    subscribe :set_skater, 'lineup_tracker#set_skater'
    subscribe :set_lineup_status, 'lineup_tracker#set_lineup_status'
    subscribe :end_jam, 'lineup_tracker#end_jam'
  end

  namespace :penalty_tracker do
    subscribe :set_penalty, 'event_log#log'
    subscribe :clear_penalaty, 'event_log#log'
    subscribe :update_penalty, 'event_log#log'
    subscribe :update_penalties, 'penalty_tracker#update_penalties'
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
