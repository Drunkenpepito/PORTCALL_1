class AddPurchaseOrderToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :purchase_order, foreign_key: true
  end
end
