class ChangeIntegerInDecimalInOrderNatandGross < ActiveRecord::Migration[7.1]
  def change
    change_column :orders, :net, :decimal, default: 0.0
    change_column :orders, :gross, :decimal, default: 0.0
  end
end
