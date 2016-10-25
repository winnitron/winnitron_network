Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  resources :games
  post "/games/:uuid/zipfile_callback", to: "game_zips#create", as: :create_zipfile

  resources :arcade_machines
  resources :playlists
  resources :listings, only: [:create, :destroy]
  resources :subscriptions, only: [:create, :destroy]
  resources :users, only: [:show]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :playlists, only: [:index]
    end
  end

  get "/dash" => "pages#dash", as: :dash
  root "pages#index"
end
