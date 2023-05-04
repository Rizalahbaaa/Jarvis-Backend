Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'users#create'
    post '/login', to: 'users#login'
    get '/confirm/:id', to: 'users#confirm_email'
    post '/note/inv', to: 'users_notes#create'
    get 'note/inv/accept_invitation', to: 'users_notes#accept_invitation', as: 'accept_invitation'
    get 'note/inv/decline_invitation', to: 'users_notes#decline_invitation', as: 'decline_invitation'

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