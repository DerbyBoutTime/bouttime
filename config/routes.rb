Rails.application.routes.draw do
  get 'scoreboard/show'
  get 'js_tests/index'
  root "home#jam_timer"
  get "/jam_timer", to: "home#jam_timer"
  get "/scoreboard", to: "home#scoreboard"
end
