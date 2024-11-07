class AddSupplierIdtoContracts < ActiveRecord::Migration[7.1]
  def change
    add_reference :contracts, :supplier, foreign_key: true
  end
end
