Rails.application.routes.draw do
  root to:"contracts#index"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :contracts 
  resources :contracts , only: [:index, :show ]do
    resources :services, only: [:index, :new, :create, :show,  :edit, :destroy ]
    resources :services, only: [:show] do 
      resources :services, only: [:new, :create ]
    end
  end
end
