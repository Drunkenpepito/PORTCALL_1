class RemoveServiceFromFormula < ActiveRecord::Migration[7.1]
  def change
    remove_reference :formulas, :service, index: true, foreign_key: true
  end
end
