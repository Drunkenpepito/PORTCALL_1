class ContractsController < ApplicationController

    before_action :set_contract, only: [:show, :edit, :update, :destroy]
    
    def index
        @contracts = Contract.all
    end
    
    def show
        @services = @contract.services
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
        @contract.destroy
        redirect_to contracts_path, notice: "Contract was successfully destroyed."
    end
    
    private
    
    def set_contract
        @contract = Contract.find(params[:id])
    end
    
    def contract_params
        params.require(:contract).permit(:name)
    end
end
