Beaucoop::Application.routes.draw do
  devise_for :users
  resources :books do
    collection do
      get :search, :lookup, :warn_aged, :expire_aged
      post :search
    end
  end
  resources :contacts
  root to: 'books#index'
end
