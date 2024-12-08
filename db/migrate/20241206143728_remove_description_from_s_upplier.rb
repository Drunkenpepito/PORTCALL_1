class RemoveDescriptionFromSUpplier < ActiveRecord::Migration[7.1]
  def change
    remove_column :suppliers, :description, :string
  end
end
