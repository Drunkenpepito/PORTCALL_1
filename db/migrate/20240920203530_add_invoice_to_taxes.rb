class AddInvoiceToTaxes < ActiveRecord::Migration[7.1]
  def change
    add_reference :taxes, :invoice, foreign_key: true
  end
end
