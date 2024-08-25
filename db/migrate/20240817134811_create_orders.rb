class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
