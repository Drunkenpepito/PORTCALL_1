class AddPriceToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :budget_price, :integer
    add_column :invoices, :invoice_price, :integer
  end
end
