Rails.application.routes.draw do

  devise_for :users

  resources :dashboard, :only => [:index]
  resource :settings, :only => [:show, :update]

  resources :feeds do
    collection do
      get :refresh
      get :import
    end
  end

  resources :posts, :only => [] do
    post :favorite
    post :read
    collection do
      get :search
      get :read_all
    end
  end

  root to: 'dashboard#index'

end