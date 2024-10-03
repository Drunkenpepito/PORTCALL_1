class ServicesController < ApplicationController

    before_action :set_service, only: [:show, :edit, :update, :destroy, :calculate]
    # before_action :show_totals, only: [:show]
    
    def index
        @services = Service.all
        @contract = Contract.find(params[:contract_id])
    end

    def show
        @service = Service.includes(:variables).find(params[:id])
        @services = @service.children 
    end
    
    def new
        # 2 CAS : 
        # Cas 1: on cree un MASTERSERVICE de la vue Contract index
        #           dans ce case on cree le service root
        # Cas 2: on cree un SERVICE enfant de la vue Service show du service.parent
        #           dans ce case le service parent est @service 
        # NO! there is no 2 cases any more as data is now materialized_path2 rather than materialized_path
        
        # if params[:service_id] 
        #     @service = Service.find(params[:service_id]).children.new
        # else
        @contract = Contract.find(params[:contract_id])
        @service = Service.find(params[:service_id])
            @service = Service.new
        # end
        # @contract = Contract.find(params[:contract_id])
        # @service.contract = @contract
    end
    
    def create
        # the idea is to hae only one create for master service or for service with mother
        # @contract = Contract.find(params[:service][:contract_id])

        if params[:service_id]  # CASE SERVICE WITH PARENT
            @service_enfant = Service.find(params[:service_id]).children.new
            @service_enfant.contract = @contract
            @service_enfant.name = params[:service][:name]
            if @service_enfant.save!
                redirect_to contract_service_path(@contract, @service_enfant.parent), notice: "Service was successfully created."
            else
                render :new, status: :unprocessable_entity
            end
        else # CASE MASTERSERVICE
            @service = Service.new(service_params)
            @contract = Contract.find(params[:service][:contract_id])
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
        redirect_to service_path(@service), notice: "Service was successfully updated."
        else
        render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @service.destroy
        redirect_to services_path, notice: "Service was successfully destroyed."
    end

    def new_child # NOT USED
        @service = Service.find(params[:service_id])
        @new_child = @service.dup 
        # copy new instance with exact same data but no id as not save yet
        # allow to transfer params of service in the form 
        @new_child.parent = @service
    end

    def new_master_service
        @service = Service.new
        @contract = Contract.find(params[:contract_id])
        @service.contract= @contract
    end

    def copy_service
        @contracts = Contract.all
    end

    def calculate
        @resultat = @service.calculate 
    end

    def link_tax_service
        # je veux faire une action reactive en modifiant une data de la DB
        # Stimulus n'est pas le meilleur choix 
        # Bouton --> Action controller --> Turbo frame pour atualiser DOM parait la meilleure option dans ce cas
        # l'action necessaire est: ajouter un element de la table de jointure tax_services
        # on ecrit la route qui nous amene les params id tax et id service 
        # Il reste la methode d'ecriture du record dans la table de jointure:
        @tax = TaxRegime.find(params[:id])
        @service = Service.find(params[:service_id])
        @tax.services << @service
        respond_to do |format|
          format.html {redirect_to service_path(@service)}
          format.turbo_stream
        end
    end

    def unlink_tax_service
        @tax = TaxRegime.find(params[:id])
        @service = Service.find(params[:service_id])
        @tax.services.delete(@service)
        respond_to do |format|
          format.html {redirect_to service_path(@service)}
          format.turbo_stream
        end
    end

    private
    
    def set_service
        @service = Service.find(params[:id])
    end
    
    def service_params
        params.require(:service).permit(:name, :ancestry, :description, :value)
    end
end
