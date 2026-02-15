Rails.application.routes.draw do
  root "home#index"

  get "home", to: "home#index"
  get "random_high_five", to: "home#random_high_five"
  post "random_high_five", to: "home#random_high_five"
  get "users", to: "users#index"
  post "high_fives", to: "high_fives#create"

  get "auth/authorize", to: "auth#authorize"
  get "auth/callback", to: "auth#callback"
  delete "auth/logout", to: "auth#logout"
end
