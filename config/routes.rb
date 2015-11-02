Rails.application.routes.draw do

  devise_for :users

  resources :dashboard, :only => [:index]
  resource :settings, :only => [:show, :edit, :update]

  resources :feeds do
    collection do
      get :refresh
    end
  end

  resources :posts, :only => [] do
    post :favorite
    post :read
  end

  root to: 'dashboard#index'

end