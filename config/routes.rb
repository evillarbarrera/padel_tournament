Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root "home#index"
  
  resources :users, only: [:show, :edit, :update]

  namespace :admin do
    get "dashboard/index"
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
  end
end
