Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    get '/users', to: 'users#index'
    post '/register', to: 'users#register'

    resources :invitations
    resources :notivications
    resources :ringtones
    resources :team_notes
    resources :user_team_notes
    resources :users
    resources :profiles
    resources :jobs
    resources :teams
    resources :lists
    resources :notes
    resources :users_notes
    resources :user_teams
    resources :progress
    resources :attaches
  end
end