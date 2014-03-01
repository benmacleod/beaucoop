Beaucoop::Application.routes.draw do
  devise_for :users
  resources :books do
    collection do
      get :search, :lookup
      post :search
    end
  end
  resources :contacts
  root to: 'books#index'
end
