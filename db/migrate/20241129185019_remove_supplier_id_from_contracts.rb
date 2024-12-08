class RemoveSupplierIdFromContracts < ActiveRecord::Migration[7.1]
  def change
    remove_reference :contracts, :supplier, index: true, foreign_key: true
  end
end
