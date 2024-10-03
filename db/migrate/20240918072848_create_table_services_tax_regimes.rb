class CreateTableServicesTaxRegimes < ActiveRecord::Migration[7.1]
  def change
    create_table :services_tax_regimes, id: false  do |t|
        t.belongs_to :service
        t.belongs_to :tax_regime
    end
  end
end
