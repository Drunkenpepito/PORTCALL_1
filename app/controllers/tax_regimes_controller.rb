class TaxRegimesController < ApplicationController

  before_action :set_tax_regime, only: [:edit, :update, :destroy]

  def new
    @contract = Contract.find(params[:contract_id])
    @tax_regime = TaxRegime.new
  end

  def create
    @contract = Contract.find(params[:contract_id])
    @tax_regime = TaxRegime.new(tax_regime_params)
    @tax_regime.contract = @contract
    if @tax_regime.save!
    redirect_to contract_path(@contract), notice: "Tax was successfully created."
    else
    render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @contract = @tax_regime.contract
    if @tax_regime.update(tax_regime_params)
        redirect_to contract_path(@contract, notice: "Tax was successfully updated.")
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
      @tax_regime.destroy
      @contract = @tax_regime.contract
      redirect_to contract_path( @contract), notice: "Tax was successfully destroyed."
  end

  private
    
  def set_tax_regime
      @tax_regime = TaxRegime.find(params[:id])
  end
  
  def tax_regime_params
      params.require(:tax_regime).permit(:name, :percentage, :contract_id, :isfee)
  end
end
