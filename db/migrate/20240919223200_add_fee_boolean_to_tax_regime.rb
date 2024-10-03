class AddFeeBooleanToTaxRegime < ActiveRecord::Migration[7.1]
  def change
    add_column :tax_regimes, :isfee, :boolean
  end
end
