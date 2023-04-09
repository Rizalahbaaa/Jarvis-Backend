Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :products
    resources :jobs
    resources :transactions
    get '/users', to: 'users#index'
    post '/register', to: 'users#register'
    post '/users', to: 'users#register'
end 
end
