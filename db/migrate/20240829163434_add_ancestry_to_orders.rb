class AddAncestryToOrders < ActiveRecord::Migration[7.1]
  def change
    change_table(:orders) do |s|
      s.string "ancestry", collation: 'C', null: false
      s.index "ancestry"
    end
  end
end
