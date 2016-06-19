Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do 
      post :s3_callback
    end
  end

  resources :arcade_machines
  resources :playlists
  resources :listings, only: [:create, :destroy]
  resources :subscriptions, only: [:create, :destroy]
  resources :users, only: [:show]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :games, only: [:index]
    end
  end

  root "pages#index"
end
