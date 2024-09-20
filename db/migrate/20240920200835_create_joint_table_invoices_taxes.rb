class CreateJointTableInvoicesTaxes < ActiveRecord::Migration[7.1]
  def change
    create_table :orders_taxes , id: false do |t|
        t.belongs_to :order
        t.belongs_to :tax
    end
  end
end
