class AddFieldsToVariables < ActiveRecord::Migration[7.1]
  def change
    add_column :variables, :position, :integer
    add_column :variables, :operator, :boolean
    add_column :variables, :fixed, :boolean
    add_column :variables, :role, :string
    change_column :variables, :value, :string
  end
end
