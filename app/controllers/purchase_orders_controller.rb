class PurchaseOrdersController < ApplicationController
  
    def index
      @purchase_orders = PurchaseOrder.all
    end
      
    def new
      @purchase_order = PurchaseOrder.new
    end
  
    def create
      
      @purchase_order = PurchaseOrder.new(purchase_order_params)
      if @purchase_order.save!
        respond_to do |format|
          format.html { redirect_to purchase_order_path(@purchase_order) }
          format.turbo_stream
        end
      else
        render :new
      end
    end
  
    def destroy
      @purchase_order = PurchaseOrder.find(params[:id])
      @purchase_order.destroy
      respond_to do |format|
        format.html { redirect_to purchase_order_path(@purchase_order) }
        format.turbo_stream
      end
    end
    
    def show 
      @contracts = Contract.all
      @purchase_order = PurchaseOrder.find(params[:id])
      @service = Service.new
    end
  
 
    private
  
    def purchase_order_params
      params.require(:purchase_order).permit(:name, :description)
    end

  
end






