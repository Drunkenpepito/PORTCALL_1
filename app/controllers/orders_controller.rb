class OrdersController < ApplicationController

    # skip_before_action :authenticate_user!
    before_action :set_order, only: [:show, :edit, :update, :destroy]

    def index
    end
      
    def new
    # Order route new depends from invoice and not service / this is intentionnal developper choice 
      @order = Order.new
      @invoice = Invoice.find(params[:invoice_id])
      @contract = @invoice.contract
      @services = @contract.services
      @root_services = @services.select{ |s| s.is_root? }
      # @selectors = @services.map { |s| [s.selector_name, s.id] }
    end


    def neworderadhoc
      @order= Order.new
      @invoice =Invoice.find(params[:id])
    end

# A CHANGER 
#quand on cree un ordr ad hoc , il associe le service de nom " service not in contract " 
# ce n'est pas exactement ce que l'on veut 
# on veut que il associe le nom de l'order au nom de ce nouveau service
# on veut ensuite que ce service cree a partir de l'order ad hoc soit identifié comme service "special" cree a posteriori du contrat 
# on voudra donc changer la vue du contrat show avce la liste de services mais aussi ces services qui proviennet de ceux qui valident les fatcures 
    def createorderadhoc
      @order = Order.new(order_params)
      @order.invoice = Invoice.find(params[:id])
      @order.name = params[:order][:name]
      @order.description = params[:order][:description]
      @contract = @order.invoice.contract
      if Service.where(contract_id:@contract.id, name:"Service not in Contract").exists?
        @service = Service.where(contract_id:@contract.id, name:"Service not in Contract").first
      else
        @service = Service.create!(contract_id: @contract.id, name:"Service not in Contract", ancestry:"/", description:"this is the service model for all ad hoc orders created after invoice receipt") 
      end
        @order.service = @service
      if @order.save!
        redirect_to invoice_path(@order.invoice) 
      else
        render :neworderadhoc
      end
    end
  

    def newchildorder
      @order= Order.new
      @order.parent= Order.find(params[:id])
      @order.invoice =  @order.parent.invoice
    end

    def createchildorder
      @order = Order.new(order_params)
      # @order.invoice = Invoice.find(params[:id])
      # @order.name = params[:order][:name]
      # @order.description = params[:order][:description]
      @order.invoice = @order.parent.invoice
      @contract = @order.parent.invoice.contract
      if Service.where(contract_id:@contract.id, name:"Service not in Contract").exists?
        @service = Service.where(contract_id:@contract.id, name:"Service not in Contract").first
      else
        @service = Service.create!(contract_id: @contract.id, name:"Service not in Contract", ancestry:"/", description:"this is the service model for all ad hoc orders created after invoice receipt") 
      end
        @order.service = @service
      if @order.save!
        redirect_to invoice_path(@order.invoice) 
      else
        render :neworderadhoc
      end
    end


    def create
      @service = Service.find(params[:order][:service_id])
      @invoice = Invoice.find(params[:invoice_id])
      @order = Order.new(order_params)
      @order.name = @service.name
      @order.service = @service
      @order.invoice = @invoice
     
      if @order.save!
        orderize(@service, @order)
        @order.calculate_net
        @order.calculate_gross
        redirect_to invoice_path(@invoice) 
      else
        render :new
      end
    end
  
    def destroy
      @order.destroy!    
        redirect_to invoice_path(@order.invoice) 
    end

    def edit
    end

    def update
      if @order.update!(order_params)
        redirect_to order_path(@order), notice: "Order was successfully updated."
      else
      render :edit, status: :unprocessable_entity
      end
    end
  
    def show 
      @order = Order.includes(:order_variables).find(params[:id])
      @orders = @order.children.to_a
      @orders << @order  if @order.children.empty? 
    end
  

    def index
      @orders = Order.all
      @invoice = Invoice.find(params[:invoice_id])
    end
  
    def calculate
      @order = Order.find(params[:id])
      @resultat =   @order.calculate
    end

    def link_tax_order
      @tax = Tax.find(params[:id])
      @order = Order.find(params[:order_id])
      @tax.orders << @order
      @order.update_net
      @order.update_gross
      respond_to do |format|
        format.html {redirect_to order_path(@order.parent)}
        format.turbo_stream
      end
    end

    def unlink_tax_order
      @tax = Tax.find(params[:id])
      @order = Order.find(params[:order_id])
      @tax.orders.delete(@order)
      @order.update_net
      @order.update_gross
      respond_to do |format|
        format.html {redirect_to order_path(@order.parent)}
        format.turbo_stream
      end
    end

    private
    
    def order_params
      params.require(:order).permit(:name, :description, :ancestry, :service_id, :invoice_id, :net, :gross)
    end

    def set_order
      @order = Order.find(params[:id])
    end

    # def copytax(contract, invoice)
    #   @tab = []
    #   contract.tax_regimes.each do |t|
    #     t2 = Tax.create!(name: t.name, percentage: t.percentage, isfee: t.isfee, invoice_id:invoice.id )
    #     @tab << [t,t2]
    #   end
    # end
    
    def orderize(service,order)
      service.children.each do |s|
        o = Order.new
        o.name = s.name
        o.service_id = s.id
        o.parent = order
        o.invoice = order.invoice
        o.gross = s.gross
        o.net = s.net
        # @tab.each do |t|
        #   t[1].orders << o if t[0].services << s
        # end
        o.save!
        # get_variables(s,o) if s.variables != [] --> done with after_create Order
        orderize(s,o)
      end
    end

    # def budget_price(order)
    #   @budget_price = (order.calculate * ( 1 + order.taxes.where(isfee:true).sum(&:percentage)*0.01)).round(4)
    # end

    def get_variables(service,order)
      service.variables.each do |v|
        var = OrderVariable.new
        var.order_id = order.id
        var.name = v.name
        var.position = v.position
        var.operator = v.operator
        var.fixed = v.fixed
        var.value = v.value
        var.role = v.role
        var.save!
        # binding.pry
      end
    end


  
end
