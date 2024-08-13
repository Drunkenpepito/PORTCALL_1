Rails.application.routes.draw do

  root to:"contracts#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :contracts do
    # CAS 1 ( CAS PARTICULIER) - pour creer un masterservice, on a besoin d'un contrat
      get "add_master_service" , to: "services#new_master_service" , as: "new_master_service" # CAS UNIQUE MASTERSERVICE - que pour masterservices
      # get "index_master_services" , to: "services#index_master_services" , as: "index_master_services" # CAS UNIQUE MASTERSERVICE - que pour masterservices
      get "show_master_services" , to: "services#show_master_services" , as: "show_master_services" # CAS UNIQUE MASTERSERVICE - que pour masterservices
  end

  resources :services do 
    # ON UTILISE PAS LE NEW
    # CAS 2 ( CAS GENERAL) - pour creer un service , on a un parent
    get "add_child_service", to: "services#new_child" , as:"new_child_service"
    # resources :formulas, only: [:new, :create]
    get "copy_service", to: "services#copy_service", as:"copy_service"
    resources :variables, only: [:new, :create,]
  end
  resources :variables , only: [:show, :index,  :destroy , :edit, :update,] do
    member do
      patch :move 
    end
  end
end