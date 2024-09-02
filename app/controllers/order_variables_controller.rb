class OrderVariablesController < ApplicationController
  def edit
    @order_variable = Ordervariable.find(params[:id])
  end

  def update
    @variable = OrderVariable.find(params[:id])
    @variable.update(order_variable_params)
    respond_to do |format|
      format.html { redirect_to order_path(@variable.order) }
      format.turbo_stream
    end
  end

  private

  def order_variable_params
    params.require(:order_variable).permit(:name, :value, :operator, :fixed, :position)
  end
end
