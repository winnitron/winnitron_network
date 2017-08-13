Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  resources :games do
    member do
      get :confirm_destroy
      get :images
      get :zip
      get :executable
      get :keys
      put :save_keys
      put :publish
    end
  end

  resources :images, only: [:create, :update, :destroy]
  resources :game_zips, only: [:create, :update]

  resources :arcade_machines do
    member do
      get :confirm_destroy
      get :images
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

  resources :comments, only: [:create, :destroy]

  resources :key_maps, only: [:index]

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :playlists, only: [:index]
    end
  end

  namespace :admin do
    resources :users, ony: [:index, :edit, :update]
  end

  get "/request_builder" => "pages#request_builder", as: :request_builder
  post "/request_builder" => "users#send_builder_request", as: :send_builder_request

  get "/search" => "search#index", as: :search
  get "/feedback" => "pages#feedback", as: :feedback
  get "/dash" => "pages#dash", as: :dash
  get "/terms" => "pages#terms", as: :terms
  root "pages#index"
end
