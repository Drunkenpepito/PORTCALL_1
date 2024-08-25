class AddInvoiceIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :invoice, foreign_key: true
  end
end
