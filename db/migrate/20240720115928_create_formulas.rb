class CreateFormulas < ActiveRecord::Migration[7.1]
  def change
    create_table :formulas do |t|
      t.string :name
      t.references :service_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
