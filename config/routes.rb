Rails.application.routes.draw do
  get 'js_tests/index'
  root "home#index"
  get "/jam_timer", to: "home#jam_timer"
  get "/scoreboard", to: "scoreboard#show"
end
