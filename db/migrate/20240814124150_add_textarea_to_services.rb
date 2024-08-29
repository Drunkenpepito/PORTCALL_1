class AddTextareaToServices < ActiveRecord::Migration[7.1]
  def change
    add_column :services, :description, :text
  end
end
