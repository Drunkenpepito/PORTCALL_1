class AddFieldsToPurchaseOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :purchase_orders, :name, :string
    add_column :purchase_orders, :description, :string
    add_reference :orders, :purchase_order, foreign_key: true 
  end
end
