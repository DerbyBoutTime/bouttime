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
  subscribe :client_heartbeat, 'event_log#client_connected'
  subscribe :client_connected, 'event_log#client_disconnected'

  namespace :jam_timer do
    subscribe :start_jam, 'event_log#log'
    subscribe :stop_jam, 'event_log#log'
    subscribe :start_lineup, 'event_log#log'
    subscribe :start_clock, 'event_log#log'
    subscribe :stop_clock, 'event_log#log'
    subscribe :undo, 'event_log#log'
    subscribe :start_timeout, 'event_log#log'
    subscribe :mark_as_official_timeout, 'event_log#log'
    subscribe :mark_as_home_team_timeout, 'event_log#log'
    subscribe :mark_as_home_team_review, 'event_log#log'
    subscribe :mark_as_away_team_timeout, 'event_log#log'
    subscribe :mark_as_away_team_review, 'event_log#log'
    subscribe :mark_as_ended_by_time, 'event_log#log'
    subscribe :mark_as_ended_by_calloff, 'event_log#log'
  end

  namespace :scorekeeper do
  end

  namespace :scoreboard do
  end

  namespace :lineup_tracker do
  end

  namespace :penalty_tracker do
  end

  namespace :penalty_box_timer do
  end

  namespace :head_nso do
  end
end
