Rails.application.routes.draw do
  devise_for :users
  root "rooms#new"
  resources :users, only: [:edit, :update]
  resources :rooms, only: [:new, :create, :destroy] do
    resources :messages, only: [:index]
  end
end
