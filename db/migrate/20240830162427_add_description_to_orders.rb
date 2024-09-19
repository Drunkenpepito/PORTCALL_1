class AddDescriptionToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :description, :text
  end
end
