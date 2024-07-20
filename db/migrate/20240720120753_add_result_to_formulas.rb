class AddResultToFormulas < ActiveRecord::Migration[7.1]
  def change
    add_column :formulas, :result, :integer
  end
end
