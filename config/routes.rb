Rails.application.routes.draw do
  root "home#index"

  get "js_tests/index"

  resources :igrfs, as: "interleague_game_reporting_forms", only: [:show, :new, :create]
end
