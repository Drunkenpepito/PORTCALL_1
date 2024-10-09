class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :goodreceipt]
 
    def index
      @invoices = Invoice.all
    end
      
    def new
      @invoice = Invoice.new
    end
  
    def create
      @invoice = Invoice.new(invoice_params)
      if @invoice.save!
        @invoice.contract.tax_regimes.each do |tax| 
          t = Tax.new( 
            name: tax.name,
            percentage: tax.percentage,
            isfee: tax.isfee,
            invoice_id: @invoice.id
          )
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
      # On a mis un boutton fomulaire au lieu de simplement faire une route qui apporte le invoice id and purchase order
      # du coup, on a deja fait l'associataion du Purchase order_id a l'invoice
      if @invoice.update(invoice_params)
        @purchase_order = PurchaseOrder.find(params[:invoice][:purchase_order_id])
        @invoices = @purchase_order.invoices
        @orders =[]
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
        respond_to do |format|
          format.html { redirect_to purchase_order_path(@invoice.purchase_order) }
          format.turbo_stream
        end
      else
        render :show
      end
    end

    def unlink
      @invoice = Invoice.find(params[:id])
      @purchase_order = @invoice.purchase_order
      if @invoice.update( purchase_order_id: nil)
        
        @invoices = @purchase_order.invoices
        @orders =[]
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
        respond_to do |format|
          format.html { redirect_to purchase_order_path(@purchase_order) }
          format.turbo_stream
        end
      end
    end



                                                        # # Store tasks
                                                        # @count_tasks = 0
                                                        # filepath = "app/assets/db_tasks.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   Task.all.each do |t|
                                                        #     if t.description != nil
                                                        #       csv << ["#{t.name}","#{t.description.gsub("\n", '-----')}".gsub(/'\'/,'---'),"#{t.status}","#{t.completed}","#{t.completed_at}","#{t.position}","#{t.project.name}","#{t.created_at}","#{t.updated_at}","#{t.priority}"] 
                                                        #     else
                                                        #       csv << ["#{t.name}","#{t.description}".gsub(/'\'/,'---'),"#{t.status}","#{t.completed}","#{t.completed_at}","#{t.position}","#{t.project.name}","#{t.created_at}","#{t.updated_at}","#{t.priority}"] 
                                                        #     end
                                                        #     @count_tasks += 1
                                                        #   end
                                                        # end
                                                        
                                                        # # Store orders
                                                        # @count_orders = 0
                                                        # filepath = "app/assets/db_orders.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   Order.all.each do |o|
                                                        #     csv << ["#{o.name}","#{o.budget}","#{o.project.name}","#{o.created_at}","#{o.updated_at}","#{o.position}"] 
                                                        #     @count_orders += 1
                                                        #   end
                                                        # end
                                                        
                                                        # # Store cost_lines
                                                        # @count_cost_lines = 0
                                                        # filepath = "app/assets/db_cost_lines.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   CostLine.all.each do |cl|
                                                        #     csv << ["#{cl.name}","#{cl.description}","#{cl.unit}","#{cl.quantity}","#{cl.price}","#{cl.total}","#{cl.created_at}","#{cl.updated_at}","#{cl.project.name}"] 
                                                        #     @count_cost_lines += 1
                                                        #   end
                                                        # end

                                                        # # Store sourcing status
                                                        # @count_todo_projects = 0
                                                        # filepath = "app/assets/db_sourcing.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   csv << ["PROJECT", "NDA", "SC" , "PT", "CW", "CONTRACT" , "BUDGET", "PO", "COMMENT"]
                                                        #   Project.all.each do |p|
                                                        #     csv << [
                                                        #       "#{p.name}",
                                                        #       "#{p.NDA_complete}",
                                                        #       "#{p.supplier_connect_complete}",
                                                        #       "#{p.payment_terms_complete}",
                                                        #       "#{p.complyworks_complete}",
                                                        #       "#{p.contract_complete}",
                                                        #       "#{p.cost_complete}",
                                                        #       p.orders != nil && p.orders.count == 1  ? "#{p.orders.first.name}":"#{p.orders.map(&:name)}",
                                                        #       "#{p.todo}"
                                                        #     ] 
                                                        #     @count_todo_projects += 1
                                                        #   end
                                                        # end

                                                        # # Store suppliers
                                                        # @count_suppliers = 0
                                                        # filepath = "app/assets/db_suppliers.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   csv << ["SUPPLIER", "CONTACT", "NDA", "SC", "CW", "MSA", "ISM", "SERVICE", "REGION", "COMMENT"]
                                                        #   Supplier.all.each do |s|
                                                        #     csv << [
                                                        #       "#{s.name}",
                                                        #       "#{s.contact}",
                                                        #       "#{s.nda}",
                                                        #       "#{s.sc}",
                                                        #       "#{s.cw}",
                                                        #       "#{s.msa}",
                                                        #       "#{s.ism}",
                                                        #       "#{s.commodity}",
                                                        #       "#{s.region}",
                                                        #       "#{s.comment_onboarding}",
                                                        #     ] 
                                                        #     @count_suppliers += 1
                                                        #   end
                                                        # end

                                                        # # Store invoices
                                                        # @count_invoices = 0
                                                        # filepath = "app/assets/db_invoices.csv"
                                                        # CSV.open(filepath, "wb") do |csv|
                                                        #   #csv << ["INVOICE", "DATE", "DESCRIPTION", "GR", "ARCHIVED", "TOTAL", "PROJECT"] it prevents db:seed to work correctly 
                                                        #   Invoice.all.each do |i|
                                                        #     csv << [
                                                        #       "#{i.number}",
                                                        #       "#{i.date}",
                                                        #       "#{i.description}",
                                                        #       "#{i.goods_receipt}",
                                                        #       "#{i.archived}",
                                                        #       "#{i.total}",
                                                        #       "#{i.project.name}",
                                                        #     ] 
                                                        #     @count_invoices += 1
                                                        #   end
                                                        # end
                                                        
      
  





    private

    def set_invoice
      @invoice = Invoice.find(params[:id])
    end
  
    def invoice_params
      params.require(:invoice).permit(:name, :description, :contract_id, :purchase_order_id)
    end

  
end

