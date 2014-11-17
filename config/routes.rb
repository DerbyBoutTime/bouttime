Rails.application.routes.draw do
  get 'scoreboard/show'
  get 'js_tests/index'
  root "home#index"
  get "/jam_timer", to: "home#jam_timer"
end
