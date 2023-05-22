require 'sidekiq/web'
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'users#create'
    post '/login', to: 'users#login'
    get '/active_user', to: 'users#active_user'
    get '/confirm/:id', to: 'users#confirm_email'
    post '/resend', to: 'users#resend_verification'

    post '/forgot_password', to: 'users#forgot'
    get '/resetpassword/:token', to: 'users#reset'
    get '/check_reset/:token', to: 'users#check_reset'
    patch '/resetpassword/:token', to: 'users#reset'

    post '/note/inv', to: 'users_notes#create'
    get 'note/inv/accept_invitation', to: 'users_notes#accept_invitation', as: 'accept_invitation'
    get 'note/inv/decline_invitation', to: 'users_notes#decline_invitation', as: 'decline_invitation'
    get 'team/inv/accept_invitation', to: 'user_teams#accept_invitation', as: 'accept_team_invitation'
    get 'team/inv/decline_invitation', to: 'user_teams#decline_invitation', as: 'decline_team_invitation'

    get '/user_notes/on_progress', to: 'users_notes#on_progress'
    get '/user_notes/completed', to: 'users_notes#completed'
    get '/user_notes/late', to: 'users_notes#late'

    get '/search_email', to: 'notes#email_valid'
    get '/history', to: 'users_notes#history'
    put '/update_password', to: 'users#update_password'

    resources :transactions do
      member do
        get  'history', to: 'transactions#history'
      end
    end
    resources :users do
      member do
        get 'point', to: 'users#point'
      end
    end
    resources :products
    resources :invitations
    resources :notivications
    resources :ringtones
    resources :team_notes
    resources :users
    resources :teams do
      member do
        post :kick_member
        post :leave_member
      end
    end
    resources :columns
    resources :notes
    resources :users_notes
    resources :user_teams
    resources :attaches
  end
end
