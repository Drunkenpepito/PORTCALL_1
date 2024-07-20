class CreateVariables < ActiveRecord::Migration[7.1]
  def change
    create_table :variables do |t|
      t.string :name
      t.integer :value
      t.references :formula, null: false, foreign_key: true

      t.timestamps
    end
  end
end
