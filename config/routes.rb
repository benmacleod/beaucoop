Beaucoop::Application.routes.draw do
  devise_for :users
  resources :books
  resource :book, only: :show
end
