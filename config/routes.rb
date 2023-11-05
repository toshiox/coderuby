Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  n.routes.draw do
    namespace :api do
      resources :items, only: [:index]
    end
  end
end
