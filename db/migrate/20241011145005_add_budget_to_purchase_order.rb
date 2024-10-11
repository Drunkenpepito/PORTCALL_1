class AddBudgetToPurchaseOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :purchase_orders, :budget, :integer
  end
end
