class AddSpendToPurchaseOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :purchase_orders, :spend, :integer, default: 0
  end
end
