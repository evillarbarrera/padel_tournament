Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root "home#index"
  
  resources :users, only: [:show, :edit, :update]
  
end
