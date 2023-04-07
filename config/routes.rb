Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    get '/users', to: 'users#index'
    post '/register', to: 'users#register'

    resources :profiles
    resources :jobs
    resources :teams
    resources :lists
    resources :notes
    resources :users_notes
  end
end
