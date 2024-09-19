class CreateTaxModels < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_models do |t|
      t.string :name
      t.integer :percentage

      t.timestamps
    end
  end
end
