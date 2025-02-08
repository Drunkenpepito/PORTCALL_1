class AddDefaultValueToPoLinesValue < ActiveRecord::Migration[7.1]
  def change
    change_column_default :po_lines, :value, 0
  end
end
