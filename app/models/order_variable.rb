class OrderVariable < ApplicationRecord
  belongs_to :order
  acts_as_list scope: :order

  after_create :order_update_gross_and_net, :update_budget_price_and_invoice_price 
  after_update_commit :order_update_gross_and_net, :update_budget_price_and_invoice_price 
  after_destroy_commit :order_update_gross_and_net, :update_budget_price_and_invoice_price

  private

  def order_update_gross_and_net
    order.update_gross_and_net
    order.ancestors.each(&:update_gross_and_net)
  end

  def update_budget_price_and_invoice_price
    return unless order.invoice.present?
    order.invoice.calculate_budget_price
    order.invoice.calculate_invoice_price
  end
end
