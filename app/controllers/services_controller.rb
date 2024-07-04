class ServicesController < ApplicationController

    before_action :set_service, only: [:show, :edit, :update, :destroy]
    
    def index
        @services = Service.all
        @contract = Contract.find(params[:contract_id])
    end
    
    def show
        @service = Service.find(params[:id])
        @contract = Contract.find(params[:contract_id])
        @services = @service.children 
    end
    
    def new
        # 2 CAS : 
        # Cas 1: on cree un MASTERSERVICE de la vue Contract index
        #           dans ce case on cree le service root
        # Cas 2: on cree un SERVICE enfant de la vue Service show du service.parent
        #           dans ce case le service parent est @service 
        # NO! there is no 2 cases any more as data is now materialized_path2 rather than materialized_path
        
        if params[:service_id] 
            @service = Service.find(params[:service_id]).children.new
        else
            @service = Service.new
        end
        @contract = Contract.find(params[:contract_id])
        @service.contract = @contract
    end
    
    def create
        @contract = Contract.find(params[:contract_id])
        if params[:service_id] 
            @service_enfant = Service.find(params[:service_id]).children.new
            @service_enfant.contract = @contract
            @service_enfant.name = params[:service][:name]
            if @service_enfant.save!
                redirect_to contract_service_path(@contract, @service_enfant.parent), notice: "Service was successfully created."
            else
                render :new, status: :unprocessable_entity
            end
        else
            @service = Service.new(service_params)
            @service.contract = @contract
            if @service.save!
                redirect_to contract_path(@contract), notice: "Service was successfully created."
            else
                render :new, status: :unprocessable_entity
            end
        end
    end
    
    def edit
    end
    
    def update
        if @service.update(service_params)
        redirect_to contract_services_path, notice: "Service was successfully updated."
        else
        render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @service.destroy
        redirect_to contract_services_path, notice: "Service was successfully destroyed."
    end
    
    private
    
    def set_service
        @service = Service.find(params[:id])
    end
    
    def service_params
        params.require(:service).permit(:name, :ancestry)
    end
end
