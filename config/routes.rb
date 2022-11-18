Rails.application.routes.draw do
  resources :users
  resources :deals
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

  post '/deals/fulfill', to: 'deals#fulfill'
  post '/login', to: 'users#login'
  post '/logout', to: 'users#logout'
end
