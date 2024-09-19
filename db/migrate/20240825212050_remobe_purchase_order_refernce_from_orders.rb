class RemobePurchaseOrderRefernceFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_reference :orders, :purchase_order, index: true, foreign_key: true
  end
end
