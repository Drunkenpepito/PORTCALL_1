class RemoveFormulaFromVariables < ActiveRecord::Migration[7.1]
  def change
    remove_reference :variables, :formula, index: true, foreign_key: true
  end
end
