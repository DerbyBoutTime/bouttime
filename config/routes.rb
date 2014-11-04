Rails.application.routes.draw do
  root "home#index"
  get "/jam_timer", to: "home#jam_timer"
end
