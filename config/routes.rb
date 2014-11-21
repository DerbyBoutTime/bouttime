Rails.application.routes.draw do
  get "scoreboard/show"
  get "js_tests/index"

  resources :games do
    get "jam_timer", on: :member, to: "displays#jam_timer"
    get "scorekeeper", on: :member, to: "displays#scorekeeper"
  end

  root "home#index"
end
