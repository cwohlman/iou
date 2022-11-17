Rails.application.routes.draw do
  root "transactions#index"
  
  get "/transactions", to: "transactions#index"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end