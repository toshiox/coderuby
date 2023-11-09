Rails.application.routes.draw do
  namespace :api do
    resources :items, only: [:index, :show, :create, :update, :destroy]
    resources :articles, only: [:index, :show, :create, :update, :destroy]
    resources :translate, only: [:index, :show, :create, :update, :destroy]
  end
end