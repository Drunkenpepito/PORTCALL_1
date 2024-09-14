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
      @services = @contract.services.select{|s| s.is_root? == true}

    end
  
    def create
      @service = Service.find(params[:order][:service_id])
      @invoice = Invoice.find(params[:invoice_id])
      @order = Order.new(order_params)
      @order.name = @service.name
      @order.service = @service
      @order.invoice = @invoice
      if @order.save!
        # get_variables(@service,@order) if @service.variables != []
        orderize(@service, @order)
        respond_to do |format|
          format.html { redirect_to invoice_path(@invoice) }
          format.turbo_stream
        end
      else
        raise
        render :new
      end
    end
  
    def destroy
      @order.destroy
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.turbo_stream
      end
    end

    def edit
    end

    def update
      if @order.update(order_params)
      redirect_to order_path(@order), notice: "Order was successfully updated."
      else
      render :edit, status: :unprocessable_entity
      end
    end
  
    def show 
      @order = Order.includes(:order_variables).find(params[:id])
      @orders = @order.children 
    end
  
    def calculate
      @order = Order.find(params[:id])
      @resultat = @order.calculate
    end

    def index
      @orders = Order.all
      @invoice = Invoice.find(params[:invoice_id])
    end
  
    def calculate
      @order = Order.find(params[:id])
      @resultat =   @order.calculate
    end

    private
    
    def order_params
      params.require(:order).permit(:name)
    end

    def set_order
      @service = Order.find(params[:id])
    end

    def orderize(service,order)
      service.children.each do |s|
        o = Order.new
        o.name = s.name
        o.service_id = s.id
        o.parent = order
        o.invoice = order.invoice
        o.save!
        # get_variables(s,o) if s.variables != []
        orderize(s,o)
      end
    end

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
