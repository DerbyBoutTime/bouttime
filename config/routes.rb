Rails.application.routes.draw do
  root "home#index"
  get 'events/generic'
  get 'scoreboard/show'
  get 'js_tests/index'
  get "/jam_timer", to: "home#jam_timer"
end
