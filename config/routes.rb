Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  resources :games do
    member do
      get :confirm_destroy
    end
  end

  post "/games/:uuid/zip", to: "game_zips#create", as: :create_zipfile
  put  "/games/:uuid/zips/:file_key", to: "game_zips#update", as: :update_zipfile
  post "images/:uuid/", to: "images#create", as: :create_image

  resources :images, only: [:update, :destroy]

  resources :arcade_machines do
    member do
      get :confirm_destroy
    end
  end

  resources :playlists do
    member do
      get :confirm_destroy
    end
  end

  resources :listings, only: [:create, :destroy]
  resources :subscriptions, only: [:create, :destroy]
  resources :users, only: [:show]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :playlists, only: [:index]
    end
  end

  post "/request_builder" => "users#send_builder_request", as: :send_builder_request

  get "/feedback" => "pages#feedback", as: :feedback
  get "/dash" => "pages#dash", as: :dash
  get "/request_builder" => "pages#request_builder", as: :request_builder
  root "pages#index"
end
