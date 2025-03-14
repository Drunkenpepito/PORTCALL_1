class OrderVariablesController < ApplicationController
  
  def new
    @order_variable = OrderVariable.new
  end

def create
    @order = Order.find(params[:order_id])
    @order_variable = OrderVariable.new(order_variable_params)
    @order_variable.order = @order
    if @order_variable.save
      respond_to do |format|
        format.html { redirect_to order_path(@order) }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @order_variable = OrderVariable.find(params[:id])
    @order = @order_variable.order
  end

  def update
    @order_variable = OrderVariable.find(params[:id])
    @order = @order_variable.order
    @invoice = @order.invoice
    if @order_variable.update(order_variable_params)
      respond_to do |format|
        format.html { redirect_to order_path(@order_variable.order) }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @order_variable = OrderVariable.find(params[:id])
  end

  def destroy
    @order_variable = OrderVariable.find(params[:id])
    @order = @order_variable.order
    @order_variable.destroy
    respond_to do |format|
      format.html { redirect_to order_path(@order_variable.order) }
      format.turbo_stream
    end
  end

  private

  def order_variable_params
    params.require(:order_variable).permit(:name, :value, :operator, :fixed, :position, :role, :order_id)
  end
end
