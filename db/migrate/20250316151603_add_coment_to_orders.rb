class AddComentToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :comment, :text 
  end
end
