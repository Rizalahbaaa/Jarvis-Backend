Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    post '/register', to: 'users#register'
    post '/login', to: 'users#login'

    resources :products
    resources :reminders
    resources :transactions
    resources :invitations
    resources :notivications
    resources :ringtones
    resources :team_notes
    resources :user_team_notes
    resources :users
    resources :teams
    resources :columns
    resources :notes
    resources :users_notes
    resources :user_teams
    resources :progress
    resources :attaches
  end
end