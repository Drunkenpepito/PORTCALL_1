class ChangsTaxToDecimals < ActiveRecord::Migration[7.1]
  def change
    change_column :tax_regimes, :percentage, :decimal, default: 0.0
    change_column :taxes, :percentage, :decimal, default: 0.0
  end
end
