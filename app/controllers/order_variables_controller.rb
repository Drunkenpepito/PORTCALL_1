class OrderVariablesController < ApplicationController
  def edit
    @order_variable = OrderVariable.find(params[:id])
  end

  def update
    @order_variable = OrderVariable.find(params[:id])
    if @order_variable.update(order_variable_params)
        redirect_to order_path( @order_variable.order), notice: "Variable was successfully updated."
    else
        render :edit, status: :unprocessable_entity
    end
  end

  private

  def order_variable_params
    params.require(:order_variable).permit(:name, :value, :operator, :fixed, :position)
  end
end
