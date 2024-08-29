class OrdersController < ApplicationController

    # skip_before_action :authenticate_user!
  
    def index
    end
      
    def new
    # Order route new depends from invoice and not service / this is intentionnal developper choice 
      @order = Order.new
      @contracts = Contract.all
      @services = Service.where(:contract_id)
      @invoice = Invoice.find(params[:invoice_id])
    end
  
    def create
      @service = Service.find(params[:service_id])
      @order = Order.new(order_params)
      @order.service = @service
      if @order.save
        respond_to do |format|
          format.html { redirect_to order_path(@order) }
          format.turbo_stream
        end
      else
        render :new
      end
    end
  
    def destroy
      @order = Order.find(params[:id])
      @order.destroy
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.turbo_stream
      end
    end
  
    def show 
      @order = Order.includes(:order_variables).find(params[:id])
    end
  
    def calculate
      @order = Order.find(params[:id])
      @resultat = @order.calculate
    end
  
    private
  
    def order_params
      params.require(:order).permit(:name)
    end

  
end
