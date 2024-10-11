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
          format.html { redirect_to purchase_orders_path }
          # format.turbo_stream
        end
      else
        render :new
      end
    end
    def edit
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    def update
      @purchase_order = PurchaseOrder.find(params[:id])
      if @purchase_order.update(purchase_order_params)
      redirect_to purchase_order_path(@purchase_order), notice: "PO was successfully updated."
      else
      render :edit, status: :unprocessable_entity
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
      @purchase_order = PurchaseOrder.find(params[:id])
      @invoices = @purchase_order.invoices
      @nopo_invoices = Invoice.where(purchase_order_id: nil)
      @orders = [] 
      @po_invoiced = 0
      @po_budgeted = 0
      @invoices.each do |i|
        i.orders.each do|o|
            if o.is_root?
              @orders << o 
              @po_invoiced += o.invoice_price
              @po_budgeted += o.budget_price
            end
        end
      end
      @services_id = @orders.map(&:service_id)
      @services = Service.where(id:@services_id)
    end

  def reset_calculate
    
  end
   

    private
  
    def purchase_order_params
      params.require(:purchase_order).permit(:name, :description, :budget)
    end

  
end






