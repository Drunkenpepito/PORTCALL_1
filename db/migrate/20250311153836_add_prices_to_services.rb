class AddPricesToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :net, :integer, default: 0
    add_column :services, :gross, :integer, default: 0
  end
end
