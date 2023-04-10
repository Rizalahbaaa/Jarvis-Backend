Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    get '/users', to: 'users#index'
    post '/register', to: 'users#register'
    resources :products
    resources :jobs
    resources :transactions
    resources :invitations
    resources :notivications
    resources :ringtones
    resources :team_notes
    resources :user_team_notes
    resources :users
    resources :profiles
    resources :teams
    resources :lists
    resources :notes
    resources :users_notes
    resources :user_teams
    resources :progress
    resources :attaches
  end 
end