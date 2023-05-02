Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'users#create'
    post '/login', to: 'users#login'
    get '/confirm/:id', to: 'users#confirm_email'
    post '/note_invite', to: 'users_notes#invite'
    get '/accept_noteinvitation/:noteinvitation_token', to: 'user_note#accept_invitation', as: 'accept_invitation'

    resources :users
    resources :products
    resources :transactions
    resources :notivications
    resources :ringtones
    resources :team_notes
    resources :users
    resources :teams
    resources :columns
    resources :notes
    resources :users_notes
    resources :user_teams
    resources :attaches
  end
end