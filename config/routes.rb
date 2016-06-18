Rails.application.routes.draw do
  devise_for :users

  resources :games
  resources :arcade_machines
  get "/users/:user_id/arcade_machines" => "arcade_machines#mine", as: :user_arcade_machines


  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      resources :games, only: [:index]
    end
  end

  root "pages#index"
end
