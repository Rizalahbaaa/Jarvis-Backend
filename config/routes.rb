# require 'sidekiq/web'
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # mount Sidekiq::Web => "/sidekiq"
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
    put '/resetpassword/:token', to: 'users#reset'

    post '/note/inv', to: 'users_notes#create'
    get '/reqlist', to:'users_notes#reqlist'

    # reqlist
    get 'note/inv/accept_invitation/:noteinvitation_token', to: 'users_notes#accept_invitation' 
    get 'note/inv/decline_invitation/:noteinvitation_token', to: 'users_notes#decline_invitation'
    get 'team/inv/accept_invitation/:teaminvitation_token', to: 'user_teams#accept_invitation'
    get 'team/inv/decline_invitation/:teaminvitation_token', to: 'user_teams#decline_invitation'

    # email
    get 'note/inv/accept_invitation', to: 'users_notes#accept_invitation_email', as: 'accept_invitation'
    get 'note/inv/decline_invitation', to: 'users_notes#decline_invitation_email', as: 'decline_invitation'
    get 'team/inv/accept_invitation', to: 'user_teams#accept_invitation_email', as: 'accept_team_invitation'
    get 'team/inv/decline_invitation', to: 'user_teams#decline_invitation_email', as: 'decline_team_invitation'

    get '/user_notes/on_progress', to: 'users_notes#on_progress'
    get '/user_notes/completed', to: 'users_notes#completed'
    get '/user_notes/late', to: 'users_notes#late'

    get '/search_email', to: 'notes#email_valid'
    put '/update_password', to: 'users#update_password'

    get '/accept', to: 'users_notes#accept_invitation'

    resources :transactions do
      member do
        get  'history', to: 'transactions#history'
      end
    end
    resources :users do
      member do
        get 'point', to: 'users#point'
        get 'notes_count', to: 'users#notes_count'
      end
    end
    resources :products
    resources :invitations
    resources :notifications do
      member do
        put 'mark_as_read'
      end
    end
    get '/client_notif', to: 'notifications#user_notif'

    resources :ringtones
    resources :team_notes
    resources :users
    resources :teams do
      resources :columns, only: [:index]
      member do
        post :kick_member
        post :leave_member
      end
    end
    resources :columns
    resources :notes do
      member do
        get 'history', to: 'notes#history'
        post 'remove', to: 'notes#remove_member'
        put 'complete', to: 'notes#completed_note'
      end
    end
    resources :users_notes
    resources :user_teams
    resources :attaches
  end
end
