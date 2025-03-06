class PurchaseOrdersController < ApplicationController
  

    def index
      # @purchase_orders = PurchaseOrder.all
      @q = PurchaseOrder.ransack(params[:q])
      @purchase_orders = @q.result(distinct: true) 
      
    end
      
    def new
      @purchase_order = PurchaseOrder.new
    end
  
    def create
      
      @purchase_order = PurchaseOrder.new(purchase_order_params)
      @contract = Contract.find(params[:purchase_order][:contract_id])
      @services = @contract.services.select{ |s| s.is_root? }
      if @purchase_order.save!
        @services.select{ |s| s.is_root? }.each  do |s| 
          @po_line = PoLine.new(purchase_order_id: @purchase_order.id, name: s.name)
          @po_line.save!  
        end
        @po_lines = PoLine.where(purchase_order_id: @purchase_order.id)
        respond_to do |format|
          format.html { redirect_to purchase_orders_path }
          #  format.turbo_stream
        end
      else
        render :new
      end
    end
    def edit
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    def edit_budget
      @purchase_order = PurchaseOrder.find(params[:id])
      @contract = @purchase_order.contract
      @services = @contract.services.select{ |s| s.is_root? }
      @po_lines = PoLine.where(purchase_order_id: @purchase_order.id)
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
        format.html { redirect_to purchase_orders_path }
        format.turbo_stream
      end
    end
    
    def show 
      @purchase_order = PurchaseOrder.find(params[:id])
      @po_lines = PoLine.where(purchase_order_id: @purchase_order.id)
      @purchase_order.budget = @po_lines.sum(:value)
      @purchase_order.save!
      @contract = @purchase_order.contract
      @invoices = @purchase_order.invoices
      @nopo_invoices = Invoice.where(purchase_order_id: nil, contract:@contract)
      @nopo_invoiced = @nopo_invoices.sum(&:invoice_price)
      @all_invoices = @invoices + @nopo_invoices
      @orders = [] 
      @po_invoiced = 0
      @po_budgeted = 0
      # @invoices.each do |i|
      #   i.orders.each do|o|
      #       if o.is_root?
      #         @orders << o 
      #         @po_invoiced += o.calculate_gross
      #         @po_budgeted += o.calculate_net
      #       end
      #       i.budget_price = @po_budgeted
      #       i.invoice_price = @po_invoiced
      #       i.save!
      #   end
      # end
      @services_id = @orders.map(&:service_id)
      @services = Service.where(id:@services_id)

      monthly_values = @purchase_order.payments.group_by_month(:date).sum(:value) 
      monthly_values2 = @invoices.group_by_month(:payment_date).sum(:budget_price) 

      budget = @po_lines.sum(&:value)
      @budget_data = {}
      @actual_data = {}
      @planned_data = {} 
      running_total = 0 
      running_total2 = 0
      monthly_values.sort.each do |month, value| 
        running_total += value 
        @planned_data[month] = running_total 
        @budget_data[month] = budget
      end 
      monthly_values2.sort.each do |month, budget_price|
        running_total2 += budget_price
        @actual_data[month] = running_total2
      end
       
    end

  def excel_po
    @purchase_orders = PurchaseOrder.includes(invoices: :orders).all
    p = Xlsx.po(@purchase_orders)
   
    respond_to do |format|
      format.xlsx { send_xls_file(p) }
    end
  end

  def excel_invoice
    raise
    @invoice 
  end

    private
  
    def purchase_order_params
      params.require(:purchase_order).permit(:name, :description, :budget, :contract_id)
    end

    def send_xls_file(package)
      temp_file = Tempfile.new("temp.xlsx") 
      package.serialize(temp_file.path)
      send_file temp_file,
           filename: "PO_#{Time.zone.today}.xlsx",
           type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 
    end

  
end






