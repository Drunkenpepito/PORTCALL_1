class AddCategoriesToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :commodity, :string
    add_column :projects, :category, :string
    add_column :projects, :completed, :boolean, default: false
    add_column :projects, :archived, :boolean, default: false
    add_column :projects, :box_link, :string
    add_column :projects, :todo, :text
    add_column :projects, :require_sourcing, :boolean, default: true
    add_column :projects, :image, :string
    add_reference :projects, :user, foreign_key: true, null: false
    add_reference :projects, :supplier
    add_reference :projects, :purchase_order


  end
end
