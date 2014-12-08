Rails.application.routes.draw do
  get 'scoreboard/show'
  get 'js_tests/index'
  root "home#jam_timer"
  get "/jam_timer", to: "home#jam_timer"
  get "/scoreboard", to: "home#scoreboard"
  get "/lineup_tracker", to: "home#lineup_tracker"
  get "/penalty_box", to: "home#penalty_box"
  get "/penalty_tracker", to: "home#penalty_tracker"
  get "/scorekeeper", to: "home#scorekeeper"
  get "/penalty_whiteboard", to: "home#penalty_whiteboard"
  get "/announcer", to: "home#announcer"
  get "/global_bout_notes", to: "home#global_bout_notes"
end
