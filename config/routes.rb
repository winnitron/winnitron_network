Rails.application.routes.draw do
  
  resources :arcade_machines
  devise_for :users

  resources :games

  root "pages#index"

end
