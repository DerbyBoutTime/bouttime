Rails.application.routes.draw do
  get 'scoreboard/show'
  get 'js_tests/index'
  root "home#index"
end
