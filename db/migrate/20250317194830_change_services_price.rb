class ChangeServicesPrice < ActiveRecord::Migration[7.1]
  def change
    change_column :services, :net, :decimal, default: 0.0
    change_column :services, :gross, :decimal, default: 0.0
  end
end
