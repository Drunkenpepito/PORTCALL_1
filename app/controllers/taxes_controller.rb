class TaxesController < ApplicationController

    before_action :set_tax, only: [:edit, :update, :destroy]
  
    def new
      @invoice = Invoice.find(params[:invoice_id])
      @tax = Tax.new
    end
  
    def create
      @invoice = Invoice.find(params[:invoice_id])
      @tax = Tax.new(tax_params)
      @tax.invoice = @invoice
      if @tax.save!
      redirect_to invoice_path(@invoice), notice: "Tax was successfully created."
      else
      render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      @invoice = @tax.invoice
      if @tax.update(tax_params)
          redirect_to invoice_path(@invoice, notice: "Tax was successfully updated.")
      else
          render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
        @tax.destroy
        @invoice = @tax.invoice
        redirect_to invoice_path( @invoice), notice: "Tax was successfully destroyed."
    end
  
    private
      
    def set_tax
        @tax= Tax.find(params[:id])
    end
    
    def tax_params
        params.require(:tax).permit(:name, :percentage, :invoice_id, :isfee)
    end
 
  
end
