Rails.application.routes.draw do
  
  devise_for :users

  resources :games

  root "pages#index"

end
