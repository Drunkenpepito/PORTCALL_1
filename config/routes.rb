Rails.application.routes.draw do
  devise_for :users

  root to:"contracts#index"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :suppliers, only: [:index] do
    collection do
      patch :update_list
    end
  end



  resources :contracts do
      get "add_master_service" , to: "services#new_master_service" , as: "new_master_service"
                # CAS 1 ( CAS PARTICULIER) - pour creer un masterservice, on a besoin d'un contrat
                # CAS UNIQUE MASTERSERVICE - que pour masterservices
                # get "index_master_services" , to: "services#index_master_services" , as: "index_master_services" # CAS UNIQUE MASTERSERVICE - que pour masterservices
      get "show_master_services" , to: "services#show_master_services" , as: "show_master_services"
                # CAS UNIQUE MASTERSERVICE - que pour masterservices
      resources :tax_regimes, only: [:new, :create,]
      resources :suppliers, only: [:new, :create,]
  end
  resources :tax_regimes , only: [:show, :index,  :destroy , :edit, :update,]





  resources :services do
    get "add_child_service", to: "services#new_child" , as:"new_child_service"
                # ON UTILISE PAS LE NEW
                # CAS 2 ( CAS GENERAL) - pour creer un service , on a un parent
    get "copy_service", to: "services#copy_service", as:"copy_service"
    post :paste_service

    member do
      get :calculate # permet de calculer le prix d'un service
      patch :move
    end

    resources :variables, only: [:new, :create,]
    post "tax_regimes/:id/link_tax_service", to:"services#link_tax_service", as: :link_tax
    post "tax_regimes/:id/unlink_tax_service", to:"services#unlink_tax_service", as: :unlink_tax

    collection do
      patch :change_ancestry
    end
  end






  resources :variables , only: [:show, :index,  :destroy , :edit, :update,] do
    member do
      patch :move
    end
  end





  resources :orders do # les cas nex et create order ne sont utilises que pour les orders qui ont un service dans un contrat
    member do
      get :calculate
      get :newchildorder # cas ou on veut creer un order ad hoc qui a un parent
      post "orders/:id/createchildorder", to:"orders#createchildorder", as: :createchildorder
    end
    resources :order_variables, only: [:new, :create]
    post "taxes/:id/link_tax_order", to:"orders#link_tax_order", as: :link_tax
    post "taxes/:id/unlink_tax_order", to:"orders#unlink_tax_order", as: :unlink_tax

  end
  get "invoices/:id/neworder", to:"orders#neworderadhoc", as: :neworderadhoc # cas ou on veut creer un masterorder ad hoc qui n'a pas de parent
  post "invoices/:id/neworder", to:"orders#createorderadhoc", as: :createorderadhoc





  resources :order_variables, only: [:show, :index,  :destroy , :edit, :update,] do
    member do
      patch :move
    end
  end


  resources :invoices do
    resources :orders, only: [:new, :create, :index]
    resources :taxes, only: [:new, :create,]
    get "excel_invoice", to: "invoices#excel_invoice" , as:"excel_invoice"
    member do
      patch 'unlink'
    end

    collection do
      get 'store'
    end

    member do
      patch 'goodreceipt'
    end

  end
  resources :taxes , only: [:show, :index,  :destroy , :edit, :update,]
  resources :purchase_orders
    get "excel_po", to: "purchase_orders#excel_po" , as:"excel_po"

  resources :projects, only: [:index ]
end
