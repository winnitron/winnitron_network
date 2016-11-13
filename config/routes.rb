Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  resources :games
  post "/games/:uuid/zip", to: "game_zips#create", as: :create_zipfile
  put  "/games/:uuid/zips/:file_key", to: "game_zips#update", as: :update_zipfile
  post "images/:uuid/", to: "images#create", as: :create_image


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
