class AddValueToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :value, :integer
  end
end
