class CreateTaxes < ActiveRecord::Migration[7.1]
  def change
    create_table :taxes do |t|
      t.string :name
      t.integer :percentage
      t.boolean :isfee

      t.timestamps
    end
  end
end
