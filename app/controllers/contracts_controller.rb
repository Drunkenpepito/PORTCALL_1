class ContractsController < ApplicationController

    before_action :set_contract, only: [:show, :edit, :update, :destroy]
    
    def index
        # @contracts = Contract.all
        @q = Contract.ransack(params[:q])
        @contracts = @q.result.includes(:supplier).order('updated_at DESC')
    end
    
    def show
        @services = @contract.services.includes(:variables).select{ |s| s.is_root? } # modifie grace a bullet 
        @services_all_contracts = Service.all.select{ |s| s.is_root? }

        @contract = Contract.find(params[:id])
        @service = Service.new
        @service.contract= @contract
        @tax_regimes = @contract.tax_regimes
    end
    
    def new
        @contract = Contract.new
    end
    
    def create
        @contract = Contract.new(contract_params)
    
        if @contract.save
        redirect_to contracts_path, notice: "Contract was successfully created."
        else
        render :new, status: :unprocessable_entity
        end

    end
    
    def edit
    end
    
    def update
        if @contract.update(contract_params)
        redirect_to contracts_path, notice: "Contract was successfully updated."
        else
        render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        raise
        if @contract.services.each {|s| s.orders.any? }
            alert = "Contract has services with orders, cannot be deleted"
        else
            @contract.destroy
        end
        redirect_to contracts_path, notice: "Contract was successfully destroyed."
    end


    
    private
    
    def set_contract
        @contract = Contract.find(params[:id])
    end
    
    def contract_params
        params.require(:contract).permit(:name, :supplier_id)
    end
end
