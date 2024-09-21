class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

    def index
      @invoices = Invoice.all
    end
      
    def new
      @invoice = Invoice.new
    end
  
    def create
      @invoice = Invoice.new(invoice_params)
      if @invoice.save!
        respond_to do |format|
          format.html { redirect_to invoice_path(@invoice) }
          # format.turbo_stream
        end
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @invoice.update(invoice_params)
      redirect_to invoices_path, notice: "Invoice was successfully updated."
      else
      render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @invoice.destroy
      redirect_to invoice_path(@invoice) 
    end
  
    def show 
      @invoice = Invoice.includes(:orders).find(params[:id])
      @orders = @invoice.orders.select{ |s| s.is_root? }
      @taxes = @invoice.taxes

    end
  
 
    private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
  
    def invoice_params
      params.require(:invoice).permit(:name, :description, :contract_id)
    end

  
end

