class CreatePoLines < ActiveRecord::Migration[7.1]
  def change
    create_table :po_lines do |t|
      t.string :name
      t.text :description
      t.integer :value
      t.references :purchase_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
