class AddNetAndGrossToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :net, :integer, default: 0
    add_column :orders, :gross, :integer, default: 0
  end
end
