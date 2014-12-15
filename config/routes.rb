Rails.application.routes.draw do
  root "home#index"

  get "js_tests/index"

  get "/announcers_feed", to: "home#announcers_feed"
  get "/global_bout_notes", to: "home#global_bout_notes"
  get "/jam_timer", to: "home#jam_timer"
  get "/lineup_tracker", to: "home#lineup_tracker"
  get "/penalty_box_timer", to: "home#penalty_box_timer"
  get "/penalty_tracker", to: "home#penalty_tracker"
  get "/penalty_whiteboard", to: "home#penalty_whiteboard"
  get "/scoreboard", to: "home#scoreboard"
  get "/scorekeeper", to: "home#scorekeeper"

  resources :games do
    get "jam_timer", on: :member, to: "displays#jam_timer"
    get "scorekeeper", on: :member, to: "displays#scorekeeper"
  end

  resources :igrfs, as: "interleague_game_reporting_forms", only: [:show, :new, :create]
end
