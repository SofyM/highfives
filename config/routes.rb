Rails.application.routes.draw do
  root "home#index"

  get "home", to: "home#index"
  get "login", to: "auth#authorize"
  get "auth/callback", to: "auth#callback"
  delete "logout", to: "auth#logout"
  get "random_high_five", to: "home#random_high_five"
  post "random_high_five", to: "home#random_high_five"
  get "users", to: "users#index"
  post "high_fives", to: "high_fives#create"
end
