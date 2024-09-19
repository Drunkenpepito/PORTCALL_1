class RenameTaxModelsToTaxRegimes < ActiveRecord::Migration[7.1]
  def change
    rename_table :tax_models, :tax_regimes
  end
end
