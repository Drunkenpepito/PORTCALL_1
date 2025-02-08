class AddStuffToPayment < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :value, :integer
    add_column :payments, :date, :date
    add_reference :payments, :purchase_order, foreign_key: true
  end
end
