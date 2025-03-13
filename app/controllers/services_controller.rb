class ServicesController < ApplicationController

    before_action :set_service, only: [:show, :update, :calculate]
    # after_action :update_gross_and_net, only: [:link_tax_service, :unlink_tax_service]

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
        # the idea is to have only one create for master service or for service with mother
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
        @service = Service.find(params[:id])
        @contract = @service.contract
        @services = @contract.services
    end
    
    def update
        # @service.parent= Service.find(params[:service][:parent]) if params[:service][:parent]
        
        if @service.update!(service_params)
            redirect_to service_path(@service), notice: "Service was successfully updated."
        else
            render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @service = Service.find(params[:id])
        @contract = @service.contract
        @service.destroy
        redirect_to contract_path(@contract),  notice: "Service was successfully destroyed."
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
        @service = Service.find(params[:service_id])
    end

    def paste_service
        @service_ref = Service.find(params[:service_id])
        @parent = Service.find(params[:parent])
        @service = @service_ref.dup
        @service.parent = @parent
        @service.contract = @parent.contract
        
        if @service.save!
            if @service_ref.has_children?
                create_children(@service_ref,@service) 
            else
                get_variables(@service_ref,@service) if @service_ref.variables != [] 
            end
            redirect_to service_path(@parent), notice: "Service was successfully created."
        else
            render :copy_service, status: :unprocessable_entity, notice: "Something went wrong..."
        end
    end

    def calculate
        @resultat = @service.calculate 
    end

    def link_tax_service
        @tax = TaxRegime.find(params[:id])
        @service = Service.find(params[:service_id])
        @tax.services << @service
        @service.update_gross_and_net  # recalcul synchronisé
        respond_to do |format|
          format.html {redirect_to service_path(@service.parent)}
          format.turbo_stream
        end
    end

    def unlink_tax_service
        @tax = TaxRegime.find(params[:id])
        @service = Service.find(params[:service_id])
        @tax.services.delete(@service)
        @service.update_gross_and_net
        respond_to do |format|
          format.html {redirect_to service_path(@service.parent)}
          format.turbo_stream
        end
    end

    def move
        @service = Service.find(params[:id])
        @service.parent = Service.find( position:params[:position].to_i)
        raise# ici il faut droper le drag le service.parent
        head :no_content # renvoie le http code 204 server OK et no content to send back
    end

    def change_ancestry
        @og_service = Service.find(params[:id])        
        @new_parent_service = Service.find(params[:parent_id]) unless params[:parent_id] == "123"
        @type = params[:target_type]
        if  params[:parent_id] == "123"
            @og_service.ancestry = @og_service.root.ancestry
        else
            @og_service.parent = @new_parent_service
        end
        if @og_service.save!
            request.format = :turbo_stream
             respond_to do |format|
                format.turbo_stream
                format.html {redirect_to contract_path(@og_service.contract), notice: "Service was successfully moved."}
             end
        end
    end
  # og_service.update!(ancestry: "/") #destroy ancestry
        # og id= 1
        # parent = /2/1./
        # og_service.ancestry = '/'
    private
    
    def create_children(model,service)
        model.children.reject{ |id| id == service.id }.each do |m|
            s = Service.new
            s.name = m.name
            s.parent = service
            s.contract = service.contract
            s.description = m.description
            s.agency_fee = m.agency_fee
            s.value = m.value
            s.save!
            if m.variables != [] 
                get_variables(m,s) 
            end
            if m.has_children?
                create_children(m,s) # m.children.map(&:id).reject{ |id| id == s.id }
            end
        end
    end

    def get_variables(service_ref,service)
        service_ref.variables.each do |v|
          var = Variable.new
          var.service_id = service.id
          var.name = v.name
          var.position = v.position
          var.operator = v.operator
          var.fixed = v.fixed
          var.value = v.value
          var.role = v.role
          var.save!
          # binding.pry
        end
      end

    def set_service
        @service = Service.find(params[:id])
    end

    def update_gross_and_net
        @service = Service.find(params[:service_id])
        @service.update_gross
        @service.update_net
        @service.ancestors.each(&:update_gross_and_net)
    end
    
    def service_params
        params.require(:service).permit(:name, :ancestry, :description, :value, :agency_fee)
    end
end
