module ChartUpdater
  extend ActiveSupport::Concern

  def update_chart
    po_id = params[:purchase_order_id] || params[:id]
    @purchase_order = PurchaseOrder.find(po_id)
    @po_lines = PoLine.where(purchase_order_id: @purchase_order.id)
    @invoices = @purchase_order.invoices
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
end
