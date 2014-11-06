Rails.application.routes.draw do
  get 'scoreboard_controller/show'
  root "home#index"
end
