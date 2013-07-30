Beaucoop::Application.routes.draw do
  devise_for :users
  resources :books do
    collection do
      get :search
      post :search
    end
  end
  root to: 'books#index'
end
