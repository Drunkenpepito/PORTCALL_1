module ChartUpdater
  extend ActiveSupport::Concern

  def update_chart
    # on passe @purchase_order dans le lien de la vue du remove
    # params[:id] necessaire ppur la vue show purchase order 
    
    po_id = params[:purchase_order_id] || params[:id]
    @purchase_order = PurchaseOrder.find(po_id)
    @po_lines = PoLine.where(purchase_order_id: @purchase_order.id)
    @invoices = @purchase_order.invoices
    planned_values = @purchase_order.payments.group_by_month(:date).sum(:value)
    actual_values = @invoices.group_by_month(:payment_date).sum(:budget_price)
    # budget = @po_lines.sum(&:value)
    budget = @purchase_order.budget
    @budget_data = {}
    @actual_data = {}
    @planned_data = {}
    planned_total = 0
    actual_total = 0
    planned_values.sort.each do |month, value|
      planned_total += value
      @planned_data[month] = planned_total
      @budget_data[month] = budget
    end
    actual_values.sort.each do |month, budget_price|
      actual_total += budget_price
      @actual_data[month] = actual_total
      @budget_data[month] = budget
    end
  end
end
