Rails.application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root "home#index"
  
  resources :users, only: [:show, :edit, :update]
  resources :inscripciones, only: [:new, :create, :index, :show]
  resources :parejas, only: [:create]
  resources :canchas
  get 'home/publicos', to: 'home#publicos', as: 'home_publicos'
  resources :campeonatos

  namespace :admin do
    get "dashboard/index"
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  end
end
