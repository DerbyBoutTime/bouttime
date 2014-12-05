Rails.application.routes.draw do
  root "home#index"

  get "/jam_timer", to: "home#jam_timer"
  get "/scoreboard", to: "scoreboard#show"

  resources :igrfs, as: "interleague_game_reporting_forms", only: [:show, :new, :create]

  get "js_tests/index"
end
