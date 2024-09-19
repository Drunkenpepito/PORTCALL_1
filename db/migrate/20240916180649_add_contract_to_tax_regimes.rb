class AddContractToTaxRegimes < ActiveRecord::Migration[7.1]
  def change
    add_reference :tax_regimes, :contract, foreign_key: true
  end
end
