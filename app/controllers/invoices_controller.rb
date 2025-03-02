class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :goodreceipt]
 
    def index
      # if params[:search] != nil
      #   # @supplier = Supplier.find(params[:search][:supplier_id])
      #   @invoices = Invoice.supplier(@supplier)
      # else
      #   @invoices = Invoice.all 
      # end
      @q = Invoice.includes(:orders, :purchase_order).ransack(params[:q])
      @invoices = @q.result(distinct: true) 
     
    end

 
      
    def new
      @invoice = Invoice.new
    end
  
    def create
      @invoice = Invoice.new(invoice_params)
      @tab = []
      @contract = Contract.find(params[:invoice][:contract_id])
      if @invoice.save!
        @contract.tax_regimes.each do |tax| 
          t = Tax.new( 
            name: tax.name,
            percentage: tax.percentage,
            isfee: tax.isfee,
            invoice_id: @invoice.id
          )
          @tab << [tax,t]
          t.save!
        end
        # respond_to do |format|
          # format.html { 
            redirect_to invoices_path
          # format.turbo_stream
        # end
      else
        render :new
      end
    end

    

    def edit
    end

    def edit_gr
      @invoice = Invoice.find(params[:id])
      @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
      
    end

    def update_gr
      @invoice = Invoice.find(params[:id])
      @purchase_order = PurchaseOrder.find(params[:invoice][:purchase_order_id])
      if @invoice.update(invoice_params)
        redirect_to purchase_order_path(@purchase_order)
      else
        render :edit_gr
      end
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
  


    def store
      require "csv"
      
      # Store invoices
      @count_invoices = 0
      filepath = "app/assets/db_invoices.csv"
      CSV.open(filepath, "wb") do |csv|
        Invoice.all.each do |i|
          if i.description != nil
            csv << ["#{i.name}","#{i.description.gsub("\r\n", '-----')}","#{i.created_at}","#{i.updated_at}"] 
          else  
            csv << ["#{i.name}","#{i.description}","#{i.created_at}","#{i.updated_at}"] 
          end
          @count_invoices += 1
        end
      end
      InvoiceMailer.db_backup.deliver_later

    end

    def goodreceipt
      @invoice = Invoice.find(params[:id])
      @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
      @invoice.purchase_order = @purchase_order

      if !@invoice.orders.select{ |o| o.is_root? }.all?{|o| o.calculate.is_a? Numeric } 
        flash[:alert] = "All services from this invoice do not have a valid Price. Please check invoice details before proceeding"
        redirect_to invoice_path(@invoice)
      end
  
      if @invoice.save!
        @invoices = @purchase_order.invoices
        @orders =[]
        @po_invoiced = 0
        @po_budgeted = 0
        @invoices.each do |i|
          i.orders.each do|o|
            if o.is_root?
              @orders << o 
              @po_invoiced += o.calculate_gross
              @po_budgeted += o.calculate_net
            end
          end
        end
        @services_id = @orders.map(&:service_id)
        @services = Service.where(id:@services_id)
        # respond_to do |format|
          redirect_to purchase_order_path(@invoice.purchase_order) 
          # format.turbo_stream
        # end
      else
        render :show
      end

    end
    

    def unlink
      @invoice = Invoice.find(params[:id])
      @purchase_order = @invoice.purchase_order
      
      
      if @invoice.update( purchase_order_id: nil)
        
        @invoices = @purchase_order.invoices
        @nopo_invoices = Invoice.where(purchase_order_id: nil, contract:@contract)
        @all_invoices = @invoices + @nopo_invoices

        @orders =[]
        @po_invoiced = 0
        @po_budgeted = 0
        @invoices.each do |i|
          i.orders.each do|o|
            if o.is_root?
              @orders << o 
              @po_invoiced += o.calculate_gross
              @po_budgeted += o.calculate_net
            end
          end
        end
        @services_id = @orders.map(&:service_id)
        @services = Service.where(id:@services_id)
        respond_to do |format|
          # redirect_to purchase_order_path(@purchase_order) 
          format.turbo_stream
        end
      end
    end


    def excel_invoice
      @invoice=Invoice.find( params[:invoice_id])
      p = Xlsx.invoice(@invoice)
   
      respond_to do |format|
        format.xlsx { send_xls_file(p) }
      end
    end
      


    private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
  
    def invoice_params
      params.require(:invoice).permit(:name, :description, :contract_id, :purchase_order_id, :good_receipt, :payment_date)
    end

    def send_xls_file(package)
      temp_file = Tempfile.new("temp.xlsx") 
      package.serialize(temp_file.path)
      send_file temp_file,
           filename: "INVOICE_#{@invoice.name}_#{Time.zone.today}.xlsx",
           type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" 
    end

  
end

