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
      get :checklist
      put :publish
    end
  end

  resources :images, only: [:create, :update, :destroy]
  resources :game_zips, only: [:create, :update]

  resources :arcade_machines do
    collection do
      get "map" => "arcade_machines#map", as: :map
    end

    member do
      get :confirm_destroy
      get :images

      resources :approval_requests, only: [:new, :update, :show], controller: :approval_requests
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
      resources :plays, only: [] do
        collection do
          post :start
        end

        member do
          put  :stop
        end
      end
    end
  end

  namespace :admin do
    resources :users, ony: [:index, :edit, :update]
    resources :approval_requests, only: [:index, :edit, :update]
  end

  get "/search" => "search#index", as: :search
  get "/feedback" => "pages#feedback", as: :feedback
  get "/contact" => "pages#feedback", as: :contact
  get "/dash" => "pages#dash", as: :dash
  get "/terms" => "pages#terms", as: :terms
  root "pages#index"
end
