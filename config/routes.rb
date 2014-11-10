Rails.application.routes.draw do
  get 'scoreboard/show'
  root "home#index"
end
