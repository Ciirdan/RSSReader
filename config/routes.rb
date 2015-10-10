Rails.application.routes.draw do

  devise_for :users

  resources :dashboard
  resources :feeds

  root to: 'feeds#index'

end
