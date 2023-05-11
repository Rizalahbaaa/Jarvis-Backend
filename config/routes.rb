Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    post '/register', to: 'users#create'
    post '/login', to: 'users#login'
    get '/active_user', to: 'users#active_user'
    get '/confirm/:id', to: 'users#confirm_email'

    post '/forgot_password', to: 'users#forgot'
    get '/reset_password/:token', to: 'users#reset'
    patch '/reset_password/:token', to: 'users#reset'

    post '/note/inv', to: 'users_notes#create'
    get 'note/inv/accept_invitation', to: 'users_notes#accept_invitation', as: 'accept_invitation'
    get 'note/inv/decline_invitation', to: 'users_notes#decline_invitation', as: 'decline_invitation'
    get 'team/inv/accept_invitation', to: 'user_teams#accept_invitation', as: 'accept_team_invitation'
    get 'team/inv/decline_invitation', to: 'user_teams#decline_invitation', as: 'decline_team_invitation'

    get '/user_notes/on_progress', to: 'users_notes#on_progress'
    get '/user_notes/completed', to: 'users_notes#completed'
    get '/user_notes/late', to: 'users_notes#late'

    get '/search_email', to: 'notes#email_valid'
    put '/update_password', to: 'users#update_password'

    resources :transactions do
      collection do
        get :history
      end
    end
    resources :users
    resources :products
    resources :invitations
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
