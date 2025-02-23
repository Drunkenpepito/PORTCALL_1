class AddStuffToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :good_receipt, :string
    add_column :invoices, :payment_date, :date
  end
end
