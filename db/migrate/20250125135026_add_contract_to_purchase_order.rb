class AddContractToPurchaseOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :purchase_orders, :contract, foreign_key: true
  end
end
