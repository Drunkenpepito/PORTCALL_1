class CreateOrderVariables < ActiveRecord::Migration[7.1]
  def change
    create_table :order_variables do |t|
      t.string :name
      t.integer :position
      t.boolean :operator
      t.boolean :fixed
      t.string :value
      t.string :role
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
