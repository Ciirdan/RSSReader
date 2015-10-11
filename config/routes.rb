Rails.application.routes.draw do

  devise_for :users

  resources :dashboard

  resources :feeds

  resources :posts, :only => [] do
    post :favorite
    post :read
  end

  root to: 'feeds#index'

end