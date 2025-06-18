Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root 'home#index'
  
  # API routes for React frontend
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'signup', to: 'registrations#create'
      
      # User profile
      get 'profile', to: 'users#show'
      put 'profile', to: 'users#update'
      patch 'profile', to: 'users#update'
    end
  end
end