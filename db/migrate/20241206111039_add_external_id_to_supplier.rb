class AddExternalIdToSupplier < ActiveRecord::Migration[7.1]
  def change
    add_column :suppliers, :external_id, :integer
  end
end
