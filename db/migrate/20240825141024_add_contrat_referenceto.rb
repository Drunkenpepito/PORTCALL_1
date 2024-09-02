class AddContratReferenceto < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :contract, foreign_key: true
  end
end
