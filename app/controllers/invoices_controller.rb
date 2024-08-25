class InvoicesController < ApplicationController
  
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
  
    def destroy
      @invoice = Invoice.find(params[:id])
      @invoice.destroy
      respond_to do |format|
        format.html { redirect_to invoice_path(@invoice) }
        format.turbo_stream
      end
    end
  
    def show 
      @invoice = Invoice.includes(:orders).find(params[:id])
    end
  
 
    private
  
    def invoice_params
      params.require(:invoice).permit(:name, :description)
    end

  
end

